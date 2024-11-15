fetch_and_test_data <- function(fetch_function, qs) {
  skip_if_not_installed("tidyselect")

  # Extract a description from the query parameters
  test_description <- sprintf(
    "Running test with fetch function: %s, filter: %s, select: %s",
    deparse(substitute(fetch_function)),
    qs$`$filter`,
    qs$`$select`
  )
  cat(test_description, "\n")

  # Fetch records
  result <- fetch_function(qs)

  # Check that the result is a data frame
  expect_s3_class(result, "data.frame")

  # Extract required columns from the query select parameter
  required_columns <- if (!is.null(qs$`$select`)) unlist(strsplit(qs$`$select`, ", ")) else character(0)
  required_columns <- c(required_columns, "Id") # Ensure 'Id' is included

  # Ensure all columns are present, adding NA for missing columns
  for (col in required_columns) {
    if (!col %in% names(result)) {
      result[[col]] <- NA
    }
  }

  # Remove duplicate column names
  names(result) <- make.unique(names(result))

  # Flatten any list columns
  result <-  dplyr::mutate(result,
                           dplyr::across(
                             tidyselect::where(is.list),
                             ~ sapply(.x, toString)))

  # Reorder columns to fit the expected format
  result <- result[, required_columns, drop = FALSE]

  # Create a temporary file for the CSV output
  output_file <- withr::local_tempfile(fileext = ".csv")

  # Write to CSV file
  write.csv(result, output_file, row.names = FALSE)

  # Check that the file exists
  expect_true(file.exists(output_file))

  # Read the file and check the contents
  saved_records <- read.csv(output_file)
  expect_s3_class(saved_records, "data.frame")

  # Check that all required columns are present
  expect_true(all(required_columns %in% names(saved_records)))

  # Clean up
  file.remove(output_file)
}
