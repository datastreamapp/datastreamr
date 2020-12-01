# An R wrapper for the DataStream public API
#
# Author: Patrick J. LeClair 2020-05-01
###############################################################################

#' Pulls information from the Records endpoint
#'
#' \code{ds_records} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the records end point. Also allows to return the count of this request.
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
#' ds_records("HJ6GY8H",select=c("Id","DatasetId"), filter=c("CharacteristicName = pH",
#' "ActivityStartDate>2019-01-01"),orderby = "ActivityStartDate",top=1000)
#'
#' ds_records("HJ6GY8H",select=c("Id","DatasetId"), filter=c("CharacteristicName = pH",
#' "ActivityStartDate>2019-01-01"),orderby = "ActivityStartDate", count = TRUE)
#' @export

ds_records <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
  if (is.null(top)) {
    top <- 1000
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
  endpoint <- "https://api.datastream.org/v1/odata/v4/Records?"
  path <- create_path(select, filter, orderby, top, count)

  url <- URLencode(paste(endpoint, path, sep = ""))
  print(url)

  if (all_data) {
    obs <- get_all_data(url, api_token)
  } else {
    obs <- get_data(url, api_token)
  }
  return(obs)
}

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
#' "ActivityStartTimeStamp>2019-01-01"),orderby = "ActivityStartDate",top=1000)
#'
#' ds_observations("HJ6GY8H",select=c("Id","DatasetId"), filter=c("CharacteristicName = pH",
#' "ActivityStartDate>2019-01-01"),orderby = "ActivityStartDate", count = TRUE)
#' @export

ds_observations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 1000
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
    path <- create_path(select, filter, orderby, top, count)

    url <- URLencode(paste(endpoint, path, sep = ""))
    print(url)

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
#' "RegionId=hub.atlantic"),orderby = "Name",top=1000)
#'
#' ds_locations("HJ6GY8H",select=c("Id","Name"), filter=c("CharacteristicName = pH",
#' "RegionId=hub.atlantic"),orderby = "Name", count = TRUE)
#' @export

ds_locations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 1000
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
    path <- create_path(select, filter, orderby, top, count)

    url <- URLencode(paste(endpoint, path, sep = ""))
    print(url)

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
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CreateTimestamp>2019-01-01",
#' "RegionId=hub.atlantic"),orderby = "Doi",top=1000)
#'
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CreateTimestamp>2019-01-01",
#' "RegionId=hub.atlantic"),orderby = "Doi", count = TRUE)
#' @export

ds_metadata <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE) {
    if (is.null(top)) {
        top <- 1000
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
    path <- create_path(select, filter, orderby, top, count)

    url <- URLencode(paste(endpoint, path, sep = ""))
    print(url)

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
#' @importFrom httr GET add_headers content
#' @importFrom jsonlite fromJSON
#' @noRd

get_data <- function(url, api_token) {
    response <- GET(url, add_headers(`x-api-key` = api_token))

    check_status(response$status_code)

    data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value

    return(data)
}

#' Uses URL to get all data from API
#'
#' Takes in the url generated by DS functions and API Token and returns data
#' @return a dataframe
#' @importFrom httr GET add_headers content
#' @importFrom jsonlite fromJSON
#' @noRd

get_all_data <- function(url, api_token) {
    obs <- data.frame()
    while (!is.null(url)) {
        response <- GET(url, add_headers(`x-api-key` = api_token))

        check_status(response$status_code)

        data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value
        obs <- rbind(obs, data)
        url <- fromJSON(content(response, "text", encoding = "UTF-8"))$`@odata.nextLink`
    }
    return(obs)
}

#' Creates API query string from function inputs
#'
#' Takes in arguments from various ds_... functions and creates the query to be appended to the appropriate API endpoint
#' @return a string
#' @importFrom stringr str_extract
#' @noRd

create_path <- function(select, filters, orderby, top, count){

    formatted_filters <- lapply(filters, function(filter)
                                paste(trimws(gsub("[=><].*","", filter)) , str_extract(filter, "[=><]"), "'",
                                      trimws(gsub(".*[=><]","", filter)), "'", sep = ""))

    formatted_filters <- gsub("=", " eq ", formatted_filters)
    formatted_filters <- gsub(">", " gt ", formatted_filters)
    formatted_filters <- gsub("<", " lt ", formatted_filters)
    formatted_filters <- gsub(">=", " gte ", formatted_filters)
    formatted_filters <- gsub("<=", " lte ", formatted_filters)

    if(length(formatted_filters) > 1){
      path <- paste("$filter=", paste(formatted_filters, collapse = " and "), "&$orderby=", paste(orderby, collapse = ","),
                    "&$select=", paste(select, collapse = ","),
                    "&$top=", top, sep = "", "&$count=", count)
    }else{
      path <- paste("$filter=", formatted_filters, "&$orderby=", paste(orderby, collapse = ","),
                    "&$select=", paste(select, collapse = ","),
                    "&$top=", top, sep = "", "&$count=", count)
    }

    return(path)
}

#' Checks status code
#'
#' Takes in the status code returned from the request and displays an error message if an error is returned
#' @return a string
#' @noRd

check_status <- function(status_code){
  if (status_code == 413) {
    stop("413: Payload too Large.Try lowering $top or only pulling the values you need")
  } else if (status_code == 504) {
    stop("504: Timeout. Lowering $top or narrowing your search criteria should resolve your issue")
  } else if (status_code == 502) {
    stop("502: Bad Gateway. Please ensure that your path is correct")
  } else if (status_code == 500) {
    stop("500: Internal Server Error. Please contact the DataStream team")
  } else if (status_code == 403) {
    stop("403: Forbidden. Please ensure that your api token is correct")
  } else if (status_code == 400) {
    stop("400: Bad Request. Please ensure that proper filters and selects are being passed")
  } else if (status_code == 200) {
    return(TRUE)
  } else {
    stop(paste(response$status_code, ": Please contact the DataStream team"))
  }
}
