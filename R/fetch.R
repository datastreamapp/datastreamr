
#' Fetch Data with Rate Limiting
#'
#' \code{fetchDataRateLimited} Fetches data from the API with rate limiting.
#' @param fetchOptions A list of fetch options including URL and query string
#' @return The API response
#' @keywords Internal
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' datastreamr:::fetchDataRateLimited(
#'  list(
#'    url = "https://api.datastream.org/v1/odata/v4/Metadata",
#'    qs = list(`$top` = 10))
#'   )
#'   }
fetchDataRateLimited <- function(fetchOptions) {
  if (!is.list(fetchOptions)) stop("fetchOptions should be a list")

  now <- Sys.time()
  rateLimitTimestamp <- getOption("datastream_rateLimitTimestamp", now)

  if (now < rateLimitTimestamp) {
    Sys.sleep(as.numeric(difftime(rateLimitTimestamp, now, units = "secs")))
  }
  options(datastream_rateLimitTimestamp = Sys.time() + getOption("datastream_rateLimit"))

  headers <- unlist(c(getOption("datastream_headers"), `x-api-key` = getOption("datastream_apiKey", "")), use.names = TRUE)

  rspns <- httr2::request(fetchOptions$url)
  rspns <- httr2::req_headers(rspns, !!!headers)
  rspns <- httr2::req_url_query(rspns, !!!fetchOptions$qs)

  cntnt <- httr2::req_perform(rspns)

  status <- httr2::resp_status(cntnt)

  if (status == 429) {
    Sys.sleep(1) # Retry after brief sleep on rate limit
    return(fetchDataRateLimited(fetchOptions))
  } else if (status >= 400) {
    stop("Error in fetch: ", status)
  }

  cntnt <- httr2::resp_body_json(cntnt)

  return(cntnt)
}

#' Fetch Data
#'
#' \code{fetchData} Fetches data from the API, handling pagination.
#' @param fetchOptions A list of fetch options including URL and query string
#' @return A dataframe of results from the API
#' @keywords Internal
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' datastreamr:::fetchData(
#'    list(
#'      getOptions(
#'        "/v1/odata/v4/Metadata",
#'        qs = list(`$top` = 10))
#'     )
#'  )
#'  }
fetchData <- function(fetchOptions) {
  is_verbose_mode <- !getOption("datastream_quiet", TRUE)

  if (!is.list(fetchOptions)) fetchOptions <- list(fetchOptions)

  result <- list()
  for (options in fetchOptions) {
    if (is_verbose_mode) message(options$url)
    cntnt <- fetchDataRateLimited(options)

    # Check if the response contains a "value" that is a list (records) or scalar (count)
    if (is.list(cntnt$value)) {
      result <- c(result, cntnt$value)
    } else {
      # Handle count scenario
      result <- c(result, list(value=list(count=as.integer(cntnt$value))))
    }

    next_link <- cntnt$`@odata.nextLink`

    while (!is.null(next_link)) {
      options$url <- next_link
      if (is_verbose_mode) message(options$url)
      cntnt <- fetchDataRateLimited(options)
      next_link <- cntnt$`@odata.nextLink`

      if (!is.null(next_link) && (next_link == options$url)) {
        stop(paste("api error at:",next_link))
      }

      if (is.list(cntnt$value)) {
        result <- c(result, cntnt$value)
      }
    }
  }

  # Convert each record's arrays to strings and handle NULLs
  converted_data <- lapply(result, function(record) {
    record <- lapply(record, function(x) {
      if (is.null(x)) {
        return(NA) # Replace NULL with NA
      }
      if (is.list(x)) {
        return(paste(unlist(x), collapse = ", ")) # Convert lists to comma-separated strings
      }
      return(x)
    })
    tibble::as_tibble(record, .name_repair = "unique")
  })

  # Bind the list of records into a data frame
  result_df <- dplyr::bind_rows(converted_data)
  if (ncol(result_df)==1 & all(colnames(result_df)=="count")) result_df <- tibble::tibble(count=sum(result_df[,1])) # Handle count scenario

  return(result_df)
}


#' Handle Partitioned Requests
#'
#' \code{partitionRequest} Handles partitioned requests to the API.
#' @param path The endpoint path for the request
#' @param qs A list of query string parameters
#' @return A dataframe of partitioned results
#' @keywords Internal
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' datastreamr:::partitionRequest("/v1/odata/v4/Records", list(`$filter` = "LocationId eq '5717'"))
#' }
partitionRequest <- function(path, qs) {
  matchPartitionedRegExp <- "(^Id| Id|^LocationId| LocationId)"

  if (grepl(matchPartitionedRegExp, qs$`$filter`)) {
    return(fetchData(list(getOptions(path, qs))))
  }

  locationStream <- locations(list(
    `$select` = "Id",
    `$filter` = gsub("LocationId", "Id", qs$`$filter`)
  ))

  if (!is.data.frame(locationStream)) {
    stop("locationStream should be a data frame")
  }

  if (nrow(locationStream)==0){
    return(locationStream)
  }

  optionsArray <- list()
  for (i in 1:nrow(locationStream)) {
    location <- locationStream[i, ]
    partitionedQs <- utils::modifyList(
      qs,
      list(
        `$filter` = paste0("LocationId eq '", location$Id, "'", if (!is.null(qs$`$filter`)) paste0(" and ", qs$`$filter`) else "")
      )
    )
    optionsArray <- append(optionsArray, list(getOptions(path, partitionedQs)))
  }

  fetchData(optionsArray)
}
