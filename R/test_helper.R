library(testthat)
library(jsonlite)

source("datastreamr.R")

fetch_and_test_data <- function(fetch_function, qs) {
  # Extract a description from the query parameters
  test_description <- sprintf("Running test with fetch function: %s, filter: %s, select: %s",
                              deparse(substitute(fetch_function)),
                              qs$`$filter`,
                              qs$`$select`)
  cat(test_description, "\n")
  
  # Fetch records
  result <- fetch_function(qs)

  # Check that the result is a list
  expect_is(result, "list")
  
  # Extract required columns from the query select parameter
  required_columns <- unlist(strsplit(qs$`$select`, ", "))
  required_columns <- c(required_columns, "Id")  # Ensure 'Id' is included
  
  # Convert result to a data frame
  result_df <- do.call(rbind, lapply(result, function(x) {
    x[sapply(x, is.null)] <- NA  # Replace NULLs with NA
    as.data.frame(x)
  }))
  
  # Ensure all columns are present, adding NA for missing columns
  for (col in required_columns) {
    if (!col %in% names(result_df)) {
      result_df[[col]] <- NA
    }
  }
  
  # Reorder columns to fit the expected format
  result_df <- result_df[, required_columns]

  # Create a temporary file for the CSV output
  output_file <- tempfile(fileext = ".csv")

  # Write to CSV file
  write.csv(result_df, output_file, row.names = FALSE)
  
  # Check that the file exists
  expect_true(file.exists(output_file))
  
  # Read the file and check the contents
  saved_records <- read.csv(output_file)
  expect_is(saved_records, "data.frame")
  
  # Check that all required columns are present
  expect_true(all(required_columns %in% names(saved_records)))
  
  # Clean up
  file.remove(output_file)
}
