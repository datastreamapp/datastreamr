FROM rocker/r-ver:4.4.1

# Install required system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    zlib1g-dev \
    pkg-config \
    libharfbuzz-dev \
    libfribidi-dev \    
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('httr', 'jsonlite', 'testthat', 'stringr', 'httptest', 'dplyr', 'tidyr', 'roxygen2'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"

# Copy your R script and test script into the Docker image
COPY R/datastreamr.R /datastreamr/R/datastreamr.R
COPY tests /datastreamr/tests

# Set the working directory
WORKDIR /datastreamr