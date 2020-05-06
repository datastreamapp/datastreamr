# An R wrapper for the DataStream public API
#
# Author: Patrick J. LeClair 2020-05-01
###############################################################################

#' Pulls information from the Observations endpoint
#'
#' \code{ds_observations} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =,<,>,<=,>=
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param FALSE Boolean. When TRUE, returns count of data instead of data
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_observations("HJ6GY8H",select=c("Id","DatasetId"), filter=c("CharacteristicName = pH",
#' "ActivityStartTimeStamp>2019-01-01"),orderby = "ActivityStartTimeStamp",top=1000)
#'
#' ds_observations("HJ6GY8H",select=c("Id","DatasetId"), filter=c("CharacteristicName = pH",
#' "ActivityStartTimeStamp>2019-01-01"),orderby = "ActivityStartTimeStamp", count = TRUE)
#' @export

ds_observations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 5000
        all_data <- TRUE
    } else {
        all_data <- FALSE
    }
    if (count == TRUE) {
        count <- "true"
        all_data <- FALSE
    } else {
        count <- "false"
    }
    endpoint <- "https://api.datastream.org/v1/odata/v4/Observations?"
    filter <- gsub("=", " eq ", filter)
    filter <- gsub(">", " gt ", filter)
    filter <- gsub("<", " lt ", filter)
    filter <- gsub(">=", " gte ", filter)
    filter <- gsub("<=", " lte ", filter)
    path <- paste("$filter=", paste(filter, collapse = " and "), "&$orderby=", paste(orderby, collapse = ","),
                  "&$select=", paste(select, collapse = ","),
                  "&$top=", top, sep = "", "&$count=", count)
    url <- URLencode(paste(endpoint, path, sep = ""))
    if (all_data) {
        obs <- get_all_data(url, api_token)
    } else {
        obs <- get_data(url, api_token)
    }
    return(obs)
}

#' Pulls information from the Locations endpoint
#'
#' \code{ds_observations} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param FALSE Boolean. When TRUE, returns count of data instead of data
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_locations("HJ6GY8H",select=c("Id","Name"), filter=c("CharacteristicName = pH",
#' "GeometryId=ds.hub.atlantic"),orderby = "Name",top=1000)
#'
#' ds_locations("HJ6GY8H",select=c("Id","Name"), filter=c("CharacteristicName = pH",
#' "GeometryId=ds.hub.atlantic"),orderby = "Name", count = TRUE)
#' @export

ds_locations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 5000
        all_data <- TRUE
    } else {
        all_data <- FALSE
    }
    if (count == TRUE) {
        count <- "true"
        all_data <- FALSE
    } else {
        count <- "false"
    }
    endpoint <- "https://api.datastream.org/v1/odata/v4/Locations?"
    filter <- gsub("=", " eq ", filter)
    filter <- gsub(">", " gt ", filter)
    filter <- gsub("<", " lt ", filter)
    filter <- gsub(">=", " gte ", filter)
    filter <- gsub("<=", " lte ", filter)
    path <- paste("$filter=", paste(filter, collapse = " and "),
                  "&$orderby=", paste(orderby, collapse = ","), "&$select=", paste(select, collapse = ","),
                  "&$top=", top, sep = "", "&$count=", count)
    url <- URLencode(paste(endpoint, path, sep = ""))
    if (all_data) {
        obs <- get_all_data(url, api_token)
    } else {
        obs <- get_data(url, api_token)
    }
    return(obs)
}

#' Pulls information from the Metadata endpoint
#'
#' \code{ds_metadata} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =,<,>,<=,>=
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param FALSE Boolean. When TRUE, returns count of data instead of data
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CharacteristicName = pH",
#' "GeometryId=ds.hub.atlantic"),orderby = "Doi",top=1000)
#'
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CharacteristicName = pH",
#' "GeometryId=ds.hub.atlantic"),orderby = "Doi", count = TRUE)
#' @export

ds_metadata <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 5000
        all_data <- TRUE
    } else {
        all_data <- FALSE
    }
    if (count == TRUE) {
        count <- "true"
        all_data <- FALSE
    } else {
        count <- "false"
    }
    endpoint <- "https://api.datastream.org/v1/odata/v4/Metadata?"
    filter <- gsub("=", " eq ", filter)
    filter <- gsub(">", " gt ", filter)
    filter <- gsub("<", " lt ", filter)
    filter <- gsub(">=", " gte ", filter)
    filter <- gsub("<=", " lte ", filter)
    path <- paste("$filter=", paste(filter, collapse = " and "), "&$orderby=", paste(orderby, collapse = ","),
                  "&$select=", paste(select, collapse = ","),
                  "&$top=", top, sep = "", "&$count=", count)
    url <- URLencode(paste(endpoint, path, sep = ""))
    if (all_data) {
        obs <- get_all_data(url, api_token)
    } else {
        obs <- get_data(url, api_token)
    }
    return(obs)
}

#' Uses URL to get data from API
#'
#' Takes in the url generated by DS functions and API Token and returns data
#' @return a dataframe
#' @importFrom httr GET add_headers
#' @importFrom jsonlite fromJSON
#' @noRd

get_data <- function(url, api_token) {
    response <- GET(url, add_headers(`x-api-key` = api_token))
    if (response$status_code == 413) {
        stop("413: Payload too Large.Try lowering $top or only pulling the values you need")
    } else if (response$status_code == 504) {
        stop("504: Timeout. Lowering $top should resolve your issue")
    } else if (response$status_code == 502) {
        stop("502: Bad Gateway. Please ensure that your path is correct")
    } else if (response$status_code == 403) {
        stop("403: Forbidden. Please ensure that your api token is correct")
    } else if (response$status_code == 400) {
      stop("400: Bad Request. Please ensure that proper filters and selects are being passed")
    } else if (response$status_code == 200) {
        data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value
    }
    return(data)
}

#' Uses URL to get all data from API
#'
#' Takes in the url generated by DS functions and API Token and returns data
#' @return a dataframe
#' @importFrom httr GET add_headers
#' @importFrom jsonlite fromJSON
#' @noRd

get_all_data <- function(url, api_token) {
    obs <- data.frame()
    while (!is.null(url)) {
        response <- GET(url, add_headers(`x-api-key` = api_token))
        if (response$status_code == 413) {
            stop("413: Payload too Large.Try lowering $top or only pulling the values you need")
        } else if (response$status_code == 504) {
            stop("504: Timeout. Lowering $top should resolve your issue")
        } else if (response$status_code == 502) {
            stop("502: Bad Gateway. Please ensure that your path is correct")
        } else if (response$status_code == 403) {
            stop("403: Forbidden. Please ensure that your api token is correct")
        } else if (response$status_code == 400) {
            stop("400: Bad Request. Please ensure that proper filters and selects are being passed")
        } else if (response$status_code == 200) {
            data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value
            obs <- rbind(obs, data)
            url <- fromJSON(content(response, "text", encoding = "UTF-8"))$`@odata.nextLink`
        }
    }
    return(obs)
}
