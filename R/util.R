#' Function to set default global options
#'
#' @keywords Internal
set_default_options <- function() {
  options(datastream_domain = "https://api.datastream.org") # Base domain for the API
  options(datastream_apiKey = Sys.getenv("DATASTREAM_API_KEY")) # API key from environment variable
  options(datastream_rateLimitTimestamp = Sys.time()) # Rate limit timestamp initialization
  options(datastream_rateLimit = 0.5) # Rate limit duration in seconds
  options(datastream_headers = c( # Base headers for requests
    Accept = "application/vnd.api+json",
    "Accept-Encoding" = "br, gzip, deflate"
  ))
}

#' .onLoad function to set options when the package is loaded
#' @param libname a character string giving the library directory where the package defining the namespace was found.
#' @param pkgname a character string giving the name of the package.
#' @keywords Internal
.onLoad <- function(libname, pkgname) {
  set_default_options()
}

#' Set API Key
#'
#' \code{setAPIKey} Sets the API key for authentication.
#' @param apiKeyParam A character string containing your unique API key
#' @examples
#' \dontrun{
#' library(datastreamr)
#' setAPIKey("your_api_key_here")
#' }
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
#' @keywords Internal
#' @examples
#' \dontrun{
#' library(datastreamr)
#' #setAPIKey("your_api_key_here")
#'
#' getOptions("/v1/odata/v4/Records", list(`$select` = "Id, DatasetId"))
#' }
getOptions <- function(path, qs) {
  list(
    url = paste0(getOption("datastream_domain"), path),
    qs = qs
  )
}
