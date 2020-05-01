# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

library(httr)
library(jsonlite)

get_all_data <- function(url, api_token){
  obs <- data.frame()
  while(!is.null(url)){
    response <- httr::GET(url, add_headers('x-api-key' = api_token))
    if (response$status_code == 413){
      stop("413: Payload too Large.Try lowering $top or only pulling the values you need")
    }else if (response$status_code == 504){
      stop("504: Timeout. Lowering $top should resolve your issue")
    }else if (response$status_code == 502){
      stop("502: Bad Gateway. Please ensure that your path is correct")
    }else if (response$status_code == 403){
      stop("403: Forbidden. Please ensure that your api token is correct")
    }else if (response$status_code == 200){
      data <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$value
      obs <- rbind(obs,data)
      url <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$`@datastream.nextLink`
    }
  }

  return(obs)
}

ds_observations <- function(path, api_token){

  endpoint <- "https://api.datastream.org/v1/odata/v4/Observations?"
  url <- URLencode(paste(endpoint,path, sep = ""))
  if (grepl(url,"top",fixed=TRUE))
  get_data(url, api_token)
}

ds_locations <- function(path, api_token){

  endpoint <- "https://api.datastream.org/v1/odata/v4/Locations?"
  url <- URLencode(paste(endpoint,path, sep = ""))
    obs <-  data.frame()
    while(!is.null(url)){
      response <- httr::GET(url, add_headers('x-api-key' = "J6VHSrbQOM5qW2bEkZgG35IeBzzajgUw6rQva7Ol"))
      data <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$value
      obs <- rbind(obs,data)
      url <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$`@datastream.nextLink`
    }
  return(obs)
}

ds_metadata <- function(path, api_token, rows = NULL){

  endpoint <- "https://api.datastream.org/v1/odata/v4/Metadata?"
  url <- URLencode(paste(endpoint,path, sep = ""))
  obs <-  data.frame()
  while(!is.null(url)){
    response <- httr::GET(url, add_headers('x-api-key' = "J6VHSrbQOM5qW2bEkZgG35IeBzzajgUw6rQva7Ol"))
    data <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$value
    obs <- rbind(obs,data)
    url <- jsonlite::fromJSON(content(response, 'text',encoding = 'UTF-8'))$`@datastream.nextLink`
  }
  return(obs)
}
