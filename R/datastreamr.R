#' Get Metadata
#'
#' \code{metadata} Retrieves metadata from the API.
#' @param qs A list of query string parameters
#' @return A dataframe of metadata results
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' metadata(list(`$select` = "Id, DatasetName"))
#' }
#' @export
metadata <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 100
  fetchData(list(getOptions("/v1/odata/v4/Metadata", qs)))
}

#' Get Locations
#'
#' \code{locations} Retrieves location data from the API.
#' @param qs A list of query string parameters
#' @return A dataframe of location results
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' locations(list(`$select` = "Id, Name"))
#' }
#' @export
locations <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  fetchData(list(getOptions("/v1/odata/v4/Locations", qs)))
}

#' Get Observations
#'
#' \code{observations} Retrieves observation data from the API.
#' @param qs A list of query string parameters
#' @return A dataframe of observation results
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' observations(list(`$select` = "Id, DatasetId"))
#' }
#' @export
observations <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  partitionRequest("/v1/odata/v4/Observations", qs)
}

#' Get Records
#'
#' \code{records} Retrieves record data from the API.
#' @param qs A list of query string parameters
#' @return A dataframe of record results
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' records(list(`$select` = "Id, DatasetId"))
#' }
#' @export
records <- function(qs) {
  if (is.null(qs$`$top`)) qs$`$top` <- 10000
  partitionRequest("/v1/odata/v4/Records", qs)
}
