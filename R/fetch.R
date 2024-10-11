
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

  response <- httr::GET(fetchOptions$url, httr::add_headers(.headers = headers), query = fetchOptions$qs)

  if (response$status_code == 429) {
    Sys.sleep(1) # Retry after brief sleep on rate limit
    return(fetchDataRateLimited(fetchOptions))
  } else if (response$status_code >= 400) {
    stop("Error in fetch: ", response$status_code)
  }

  return(response)
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
  if (!is.list(fetchOptions)) fetchOptions <- list(fetchOptions)

  result <- list()
  for (options in fetchOptions) {
    response <- fetchDataRateLimited(options)
    cntnt <- httr::content(response, as = "parsed", type = "application/json")

    # Check if the response contains a "value" that is a list (records) or scalar (count)
    if (is.list(cntnt$value)) {
      result <- c(result, cntnt$value)
    } else {
      # Handle count scenario
      return(tibble::tibble(count = as.integer(cntnt$value)))
    }

    next_link <- cntnt$`@odata.nextLink`

    while (!is.null(next_link)) {
      options$url <- next_link
      response <- fetchDataRateLimited(options)
      cnt <- httr::content(response, as = "parsed", type = "application/json")
      next_link <- cntnt$`@odata.nextLink`

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
