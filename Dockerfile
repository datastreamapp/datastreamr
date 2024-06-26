FROM rocker/r-ver:4.4.1

# Install required system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('httr', 'jsonlite', 'testthat', 'stringr', 'httptest'), repos='http://cran.rstudio.com/')"

# Copy your R script and test script into the Docker image
COPY R/datastreamr.R /usr/local/bin/datastreamr.R
COPY R/test_helper.R /usr/local/bin/test_helper.R
COPY R/test_integration.R /usr/local/bin/test_integration.R
COPY R/test_unit.R /usr/local/bin/test_unit.R

# Set the working directory
WORKDIR /usr/local/bin
