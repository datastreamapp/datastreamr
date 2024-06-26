library(httr)
library(jsonlite)

# An R wrapper for the DataStream public API
#
# Author: [Kiril Kirov] 2024-06-25
###############################################################################

# Set default global options
options(datastream_domain = "https://api.datastream.org") # Base domain for the API
options(datastream_apiKey = Sys.getenv("DATASTREAM_API_KEY")) # API key from environment variable
options(datastream_rateLimitTimestamp = Sys.time()) # Rate limit timestamp initialization
options(datastream_rateLimit = 0.05) # Rate limit duration in seconds
options(datastream_headers = c( # Base headers for requests
  Accept = 'application/vnd.api+json',
  'Accept-Encoding' = "br, gzip, deflate"
))

#' Set API Key
#'
#' \code{setAPIKey} Sets the API key for authentication.
#' @param apiKeyParam A character string containing your unique API key
#' @examples
#' setAPIKey("your_api_key_here")
#' @export
setAPIKey <- function(apiKeyParam) {
  options(datastream_apiKey = apiKeyParam)
}

#' Create Request Options
#'
#' \code{getOptions} Creates the options list for making API requests.
#' @param path The endpoint path for the request
#' @param qs A list of query string parameters
#' @return A list of request options
#' @examples
#' getOptions("/v1/odata/v4/Records", list(`$select` = "Id, DatasetId"))
#' @export
getOptions <- function(path, qs) {
  list(
    url = paste0(getOption("datastream_domain"), path),
    qs = qs
  )
}

#' Fetch Data with Rate Limiting
#'
#' \code{fetchDataRateLimited} Fetches data from the API with rate limiting.
#' @param fetchOptions A list of fetch options including URL and query string
#' @return The API response
#' @examples
#' fetchDataRateLimited(list(url = "https://api.datastream.org/v1/odata/v4/Records", qs = list(`$top` = 10)))
#' @export
fetchDataRateLimited <- function(fetchOptions) {
  if (!is.list(fetchOptions)) stop("fetchOptions should be a list")
  
  now <- Sys.time()
  rateLimitTimestamp <- getOption("datastream_rateLimitTimestamp", now)
  
  if (now < rateLimitTimestamp) {
    Sys.sleep(as.numeric(difftime(rateLimitTimestamp, now, units = "secs")))
  }
  options(datastream_rateLimitTimestamp = Sys.time() + getOption("datastream_rateLimit"))
  
  headers <- unlist(c(getOption("datastream_headers"), `x-api-key` = getOption("datastream_apiKey", "")), use.names = TRUE)
  response <- GET(fetchOptions$url, add_headers(.headers = headers), query = fetchOptions$qs)
  
  if (response$status_code == 429) {
    Sys.sleep(1) # Retry after brief sleep on rate limit
    return(fetchDataRateLimited(fetchOptions))
  } else if (response$status_code >= 400) {
    stop("Error in fetch: ", response$status_code)
  }
  
  response
}

#' Fetch Data
#'
#' \code{fetchData} Fetches data from the API, handling pagination.
#' @param fetchOptions A list of fetch options including URL and query string
#' @return A list of results from the API
#' @examples
#' fetchData(list(url = "https://api.datastream.org/v1/odata/v4/Records", qs = list(`$top` = 10)))
#' @export
fetchData <- function(fetchOptions) {
  if (!is.list(fetchOptions)) fetchOptions <- list(fetchOptions)
  
  result <- list()
  for (options in fetchOptions) {
    response <- fetchDataRateLimited(options)
    content <- content(response, as = "parsed", type = "application/json")
    result <- c(result, content$value)
    
    next_link <- content$`@odata.nextLink`
    while (!is.null(next_link)) {
      options$url <- next_link
      response <- fetchDataRateLimited(options)
      content <- content(response, as = "parsed", type = "application/json")
      result <- c(result, content$value)
      next_link <- content$`@odata.nextLink`
    }
  }
  
  result
}

#' Get Metadata
#'
#' \code{metadata} Retrieves metadata from the API.
#' @param qs A list of query string parameters
#' @return A list of metadata results
#' @examples
#' metadata(list(`$select` = "Id, DatasetName"))
#' @export
metadata <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 100
  fetchData(list(getOptions("/v1/odata/v4/Metadata", qs)))
}

#' Get Locations
#'
#' \code{locations} Retrieves location data from the API.
#' @param qs A list of query string parameters
#' @return A list of location results
#' @examples
#' locations(list(`$select` = "Id, Name"))
#' @export
locations <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  fetchData(list(getOptions("/v1/odata/v4/Locations", qs)))
}

#' Handle Partitioned Requests
#'
#' \code{partitionRequest} Handles partitioned requests to the API.
#' @param path The endpoint path for the request
#' @param qs A list of query string parameters
#' @return A list of partitioned results
#' @examples
#' partitionRequest("/v1/odata/v4/Records", list(`$filter` = "LocationId eq '5717'"))
#' @export
partitionRequest <- function(path, qs) {
  matchPartitionedRegExp <- "(^Id| Id|^LocationId| LocationId)"
  
  if (grepl(matchPartitionedRegExp, qs$`$filter`)) {
    return(fetchData(list(getOptions(path, qs))))
  }
  
  locationStream <- locations(list(
    `$select` = 'Id',
    `$filter` = gsub('LocationId', 'Id', qs$`$filter`)
  ))
  
  optionsArray <- list()
  for (location in locationStream) {
    partitionedQs <- modifyList(qs, list(
      `$filter` = paste0("LocationId eq '", location$Id, "'", if (!is.null(qs$`$filter`)) paste0(" and ", qs$`$filter`) else '')
    ))
    optionsArray <- append(optionsArray, list(getOptions(path, partitionedQs)))
  }
  fetchData(optionsArray)
}

#' Get Observations
#'
#' \code{observations} Retrieves observation data from the API.
#' @param qs A list of query string parameters
#' @return A list of observation results
#' @examples
#' observations(list(`$select` = "Id, DatasetId"))
#' @export
observations <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  partitionRequest("/v1/odata/v4/Observations", qs)
}

#' Get Records
#'
#' \code{records} Retrieves record data from the API.
#' @param qs A list of query string parameters
#' @return A list of record results
#' @examples
#' records(list(`$select` = "Id, DatasetId"))
#' @export
records <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  partitionRequest("/v1/odata/v4/Records", qs)
}
