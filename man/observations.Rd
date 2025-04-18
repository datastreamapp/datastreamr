% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datastreamr.R
\name{observations}
\alias{observations}
\title{Get Observations}
\usage{
observations(qs)
}
\arguments{
\item{qs}{A list of query string parameters}
}
\value{
A dataframe of observation results
}
\description{
\code{observations} Retrieves observation data from the API.
}
\examples{
\dontrun{
library(datastreamr)
#setAPIKey("your_api_key_here")

observations(list(`$select` = "Id, DatasetId"))
}
}
