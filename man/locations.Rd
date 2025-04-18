% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datastreamr.R
\name{locations}
\alias{locations}
\title{Get Locations}
\usage{
locations(qs)
}
\arguments{
\item{qs}{A list of query string parameters}
}
\value{
A dataframe of location results
}
\description{
\code{locations} Retrieves location data from the API.
}
\examples{
\dontrun{
library(datastreamr)
#setAPIKey("your_api_key_here")

locations(list(`$select` = "Id, Name"))
}
}
