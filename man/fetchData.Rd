% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch.R
\name{fetchData}
\alias{fetchData}
\title{Fetch Data}
\usage{
fetchData(fetchOptions)
}
\arguments{
\item{fetchOptions}{A list of fetch options including URL and query string}
}
\value{
A dataframe of results from the API
}
\description{
\code{fetchData} Fetches data from the API, handling pagination.
}
\examples{
\dontrun{
library(datastreamr)
#setAPIKey("your_api_key_here")

datastreamr:::fetchData(
   list(
     getOptions(
       "/v1/odata/v4/Metadata",
       qs = list(`$top` = 10))
    )
 )
 }
}
\keyword{Internal}
