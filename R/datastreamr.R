# An R wrapper for the DataStream public API
#
# Author: Patrick J. LeClair 2020-05-01
###############################################################################

ds_records <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
  endpoint <- "https://api.datastream.org/v1/odata/v4/Records?"
  obs = get_all_data(api_token,select, filter, orderby, top, count, skip, skiptoken,endpoint) 
  return(obs)
}


ds_observations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
  endpoint <- "https://api.datastream.org/v1/odata/v4/Observations?"
  obs = get_all_data(api_token,select, filter, orderby, top, count, skip, skiptoken,endpoint) 
  return(obs)
}


ds_locations <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
  endpoint <- "https://api.datastream.org/v1/odata/v4/Locations?"
  obs = get_all_data(api_token,select, filter, orderby, top, count, skip, skiptoken,endpoint) 
  return(obs)
}


ds_metadata <- function(api_token, select = NULL, filter = NULL, orderby = NULL, top = NULL, count = FALSE, skip = NULL, skiptoken = NULL) {
  endpoint <- "https://api.datastream.org/v1/odata/v4/Metadata?"
  obs = get_all_data(api_token,select, filter, orderby, top, count, skip, skiptoken,endpoint) 
  return(obs)
}

# Pulls data

get_all_data <- function(api_token,select, filter, orderby, top, count, skip, skiptoken,endpoint) {
  
  # Set default top and assign count
  if (is.null(top)) {
    top <- 1000} 
  if (count == TRUE) {
    count <- "true"}
  else {
    count <- "false"
  }
  
  # Build URL
  path <- create_path(select, filter, orderby, top, count, skip, skiptoken)
  url <- URLencode(paste(endpoint, path, sep = ""))
  
  
  # Pull data
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
