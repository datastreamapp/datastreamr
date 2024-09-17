# An R wrapper for the DataStream public API
#
# Author: Patrick J. LeClair 2020-05-01
###############################################################################

#' Pulls data formatted the same as the upload template including all columns listed in the schema
#'
#' \code{ds_records} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the records end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =,<,>,<=,>=,!=
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param count Boolean. When TRUE, returns count of data instead of data
#' @param skip Number string to determine how many rows to skip
#' @param skiptoken Number string returning the items after the skipped token. Cannot be paired with orderby
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_records("HJ6GY8H",select=c("Id","DatasetName"), filter=c("CharacteristicName = pH",
#' "ActivityStartYear>2019"),top=1000)
#'
#' ds_records("HJ6GY8H",select=c("Id","DatasetName"), filter=c("CharacteristicName = pH",
#' "ActivityStartYear>2019"), count = TRUE)
#' @export

ds_records <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
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
  path <- create_path(select, filter, orderby, top, count, skip, skiptoken)

  url <- URLencode(paste(endpoint, path, sep = ""))
  #print(url)

  if (all_data) {
    obs <- get_all_data(url, api_token)
  } else {
    obs <- get_data(url, api_token)
  }
  return(obs)
}

#' Pulls data in a condensed format that must be joined with other endpoints to create schema template. Meant more for app creation.
#'
#'
#' \code{ds_observations} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =,<,>,<=,>=,!=
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param count Boolean. When TRUE, returns count of data instead of data
#' @param skip Number string to determine how many rows to skip
#' @param skiptoken Number string returning the items after the skipped token. Cannot be paired with orderby
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_observations("HJ6GY8H",select=c("Id","DatasetName"), filter=c("CharacteristicName = pH",
#' "ActivityStartYear>2019"),top=1000)
#'
#' ds_observations("HJ6GY8H",select=c("Id","DatasetName"), filter=c("CharacteristicName = pH",
#' "ActivityStartYear>2019"), count = TRUE)
#' @export

ds_observations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
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
    path <- create_path(select, filter, orderby, top, count, skip, skiptoken)

    url <- URLencode(paste(endpoint, path, sep = ""))
    #print(url)

    if (all_data) {
        obs <- get_all_data(url, api_token)
    } else {
        obs <- get_data(url, api_token)
    }
    return(obs)
}

#' Pulls only the location data including Id, Name, Latitude, and Longitude.
#'
#' \code{ds_observations} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param count Boolean. When TRUE, returns count of data instead of data
#' @param skip Number string to determine how many rows to skip
#' @param skiptoken Number string returning the items after the skipped token. Cannot be paired with orderby
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_locations("HJ6GY8H",select=c("Id","Name"), filter=c("CharacteristicName = pH",
#' "RegionId=hub.atlantic"),top=1000)
#'
#' ds_locations("HJ6GY8H",select=c("Id","Name"), filter=c("CharacteristicName = pH",
#' "RegionId=hub.atlantic"), count = TRUE)
#' @export

ds_locations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
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
    path <- create_path(select, filter, orderby, top, count, skip, skiptoken)

    url <- URLencode(paste(endpoint, path, sep = ""))
    #print(url)

    if (all_data) {
        obs <- get_all_data(url, api_token)
    } else {
        obs <- get_data(url, api_token)
    }
    return(obs)
}

#' Pulls only the metadata information including dataset name, citation, license, abstract, etc.
#'
#' \code{ds_metadata} Takes in different API request criteria such as row selections and filters
#' and returns the desired data. Allows for an easy interface for calling the data
#' from the observation end point. Also allows to return the count of this request.
#' @param api_token A character string containing your unique API token
#' @param select A list of allowable columns to return
#' @param filter A list of conditions to filter by. Allowable conditions are =,<,>,<=,>=,!=
#' @param orderby List of columns to orderby
#' @param top Number string to determine number of rows to return. If NULL, returns all rows
#' @param count Boolean. When TRUE, returns count of data instead of data
#' @param skip Number string to determine how many rows to skip
#' @param skiptoken Number string returning the items after the skipped token. Cannot be paired with orderby
#'
#' @return If count = FALSE, then returns a dataframe with requested columns.
#' If count = TRUE, returns a numeric string.
#'
#' For information on allowable columns for each parameter please review the README at
#' \url{https://github.com/gordonfn/datastreamr}
#'
#' @examples
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CreateTimestamp>2019-01-01",
#' "RegionId=hub.atlantic"),top=1000)
#'
#' ds_metadata("HJ6GY8H",select=c("Id","DataCollectionOrganization"), filter=c("CreateTimestamp>2019-01-01",
#' "RegionId=hub.atlantic"), count = TRUE)
#' @export

ds_metadata <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
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
    path <- create_path(select, filter, orderby, top, count, skip, skiptoken)

    url <- URLencode(paste(endpoint, path, sep = ""))
    #print(url)

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


    if(is.null(response)){
      print("Response is NULL. Please contact the DataStream Team")
    }else{
      check_status(response$status_code)

      data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value
    }
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

        if(is.null(response)){
          url = NULL
        }else{
          check_status(response$status_code)

          data <- fromJSON(content(response, "text", encoding = "UTF-8"))$value
          obs <- rbind(obs, data)
          url <- fromJSON(content(response, "text", encoding = "UTF-8"))$`@odata.nextLink`
          #print(url)
        }
    }
    return(obs)
}

#' Creates API query string from function inputs
#'
#' Takes in arguments from various ds_... functions and creates the query to be appended to the appropriate API endpoint
#' @return a string
#' @importFrom stringr str_extract str_remove_all
#' @noRd

create_path <- function(select, filters, orderby, top, count, skip, skiptoken){

    formatted_filters <- lapply(filters, function(filter)
                                paste(trimws(gsub("[=><].*","", filter)) , str_extract(filter, "!=|<=|>=|=|<|>"), "'",
                                      if (grepl("'", filter)) {
                                        str_remove_all(trimws(gsub(".*[=><!]","", filter)),"'")                                               }
                                      else {
                                        trimws(gsub(".*[=><!]","", filter))
                                        }, "'", sep = ""))

    formatted_filters <- gsub(">=", " gte ", formatted_filters)
    formatted_filters <- gsub("<=", " lte ", formatted_filters)
    formatted_filters <- gsub("!=", " ne ", formatted_filters)
    formatted_filters <- gsub(">", " gt ", formatted_filters)
    formatted_filters <- gsub("<", " lt ", formatted_filters)
    formatted_filters <- gsub("=", " eq ", formatted_filters)


    if(length(formatted_filters) > 1){
      path <- paste("$filter=", paste(formatted_filters, collapse = " and "), "&$orderby=", paste(orderby, collapse = ","),
                    "&$select=", paste(select, collapse = ","),
                    "&$top=", top, sep = "", "&$count=", count, "&$skip=", skip, "&$skiptoken=", skiptoken)
    }else{
      path <- paste("$filter=", formatted_filters, "&$orderby=", paste(orderby, collapse = ","),
                    "&$select=", paste(select, collapse = ","),
                    "&$top=", top, sep = "", "&$count=", "&$skip=", skip, "&$skiptoken=", skiptoken)
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
  } else if (status_code == 408) {
    stop("408: Timeout. Lowering $top or narrowing your search criteria should resolve your issue")
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
    stop(paste(status_code, ": Please contact the DataStream team"))
  }
}
