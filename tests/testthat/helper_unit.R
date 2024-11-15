# Mock data for the tests
mock_data_observations <- list(
  list(Id = "1",
       DOI = "10.25976/abcd-1234",
       LocationId = "406583",
       CharacteristicName = "pH",
       ActivityType = "Sample",
       ActivityMediaName = "Water",
       ActivityStartDate = "2021-01-01",
       ActivityStartTime = "12:00",
       ActivityEndDate = "2021-01-01",
       ActivityEndTime = "13:00",
       ActivityDepthHeightMeasure = 5.0,
       ActivityDepthHeightUnit = "m",
       SampleCollectionEquipmentName = "Bottle",
       MethodSpeciation = "None",
       ResultSampleFraction = "Total",
       ResultValue = 7.0,
       ResultUnit = "pH units",
       ResultValueType = "Actual",
       ResultDetectionCondition = "None",
       ResultDetectionQuantitationLimitUnit = "mg/L",
       ResultDetectionQuantitationLimitMeasure = 0.1,
       ResultDetectionQuantitationLimitType = "DL",
       ResultStatusID = "Final",
       ResultComment = "None",
       ResultAnalyticalMethodID = "Method1",
       ResultAnalyticalMethodContext = "Context1",
       ResultAnalyticalMethodName = "Method Name",
       AnalysisStartDate = "2021-01-02",
       AnalysisStartTime = "14:00",
       AnalysisStartTimeZone = "UTC",
       LaboratoryName = "Lab1",
       LaboratorySampleID = "Sample1")
)

mock_data_records <- list(
  list(Id = "1",
       DOI = "10.25976/abcd-1234",
       DatasetName = "Dataset1",
       MonitoringLocationID = "5717",
       MonitoringLocationName = "Location1",
       MonitoringLocationLatitude = 40.7128,
       MonitoringLocationLongitude = -74.0060,
       MonitoringLocationHorizontalCoordinateReferenceSystem = "WGS84",
       MonitoringLocationHorizontalAccuracyMeasure = 1.0,
       MonitoringLocationHorizontalAccuracyUnit = "m",
       MonitoringLocationVerticalMeasure = 10.0,
       MonitoringLocationVerticalUnit = "m",
       MonitoringLocationType = "Stream",
       ActivityType = "Sample",
       ActivityMediaName = "Water",
       ActivityStartDate = "2021-01-01",
       ActivityStartTime = "12:00",
       ActivityEndDate = "2021-01-01",
       ActivityEndTime = "13:00",
       ActivityDepthHeightMeasure = 5.0,
       ActivityDepthHeightUnit = "m",
       SampleCollectionEquipmentName = "Bottle",
       CharacteristicName = "pH",
       MethodSpeciation = "None",
       ResultSampleFraction = "Total",
       ResultValue = 7.0,
       ResultUnit = "pH units",
       ResultValueType = "Actual",
       ResultDetectionCondition = "None",
       ResultDetectionQuantitationLimitMeasure = 0.1,
       ResultDetectionQuantitationLimitUnit = "mg/L",
       ResultDetectionQuantitationLimitType = "DL",
       ResultStatusID = "Final",
       ResultComment = "None",
       ResultAnalyticalMethodID = "Method1",
       ResultAnalyticalMethodContext = "Context1",
       ResultAnalyticalMethodName = "Method Name",
       AnalysisStartDate = "2021-01-02",
       AnalysisStartTime = "14:00",
       AnalysisStartTimeZone = "UTC",
       LaboratoryName = "Lab1",
       LaboratorySampleID = "Sample1")
)

mock_data_metadata <- list(
  list(
    Id = "0456bedd-cd0c-44ce-8f8d-da0afbb6694b",
    DOI = "10.25976/m2s9-oz38",
    Version = "2.45.0",
    DatasetName = "Anonymized Dataset",
    DataStewardEmail = "anonymized@example.com",
    DataCollectionOrganization = "Anonymized Organization",
    DataUploadOrganization = "Anonymized Upload Organization",
    ProgressCode = "onGoing",
    MaintenanceFrequencyCode = "asNeeded",
    Abstract = "Anonymized abstract for the dataset.",
    DataCollectionInformation = "Anonymized data collection information.",
    DataProcessing = "Anonymized data processing details.",
    FundingSources = "Anonymized funding sources",
    DataSourceURL = "https://example.com/anonymized-dataset",
    OtherDataSources = NA,
    Citation = "Anonymized Dataset. 2024. \"Anonymized Dataset\" (dataset). 2.45.0. DataStream. https://doi.org/10.25976/m2s9-oz38.",
    Licence = "https://opendatacommons.org/licenses/by/1-0/",
    Disclaimer = NA,
    TopicCategoryCode = I(list("inlandWaters")),
    Keywords = I(list("Keyword1")),
    CreateTimestamp = "2024-06-16T07:16:43.489Z",
    PublishedTimestamp = "2024-06-19T07:16:43.488Z"
  )
)

mock_data_locations <- list(
  list(Id = "1",
       DOI = "10.25976/abcd-1234",
       NameId = "Name1",
       Name = "Location1",
       Latitude = 40.7128,
       Longitude = -74.0060,
       HorizontalCoordinateReferenceSystem = "WGS84",
       HorizontalAccuracyMeasure = 1.0,
       HorizontalAccuracyUnit = "m",
       VerticalMeasure = 10.0,
       VerticalUnit = "m",
       MonitoringLocationType = "Stream",
       LatitudeNormalized = 40.7128,
       LongitudeNormalized = -74.0060)
)

# Wrapper to convert the mock data to the same format as GET responses
create_mock_response <- function(data) {
  response <- list(
    status_code = 200,
    headers = as.list(getOption("datastream_headers")),
    body = charToRaw(jsonlite::toJSON(list(value = data), auto_unbox = TRUE))
  )
  class(response) <- "httr2_response"
  return(response)
}

translate_mock_json <- function(data) {
  jsonlite::fromJSON(rawToChar(data$body),simplifyVector =F)
}

# Mock function to replace the actual GET call
mock_get <- function(url, ...) {
  url<-url$url
  if (grepl("Observations", url)) {
    return(create_mock_response(mock_data_observations))
  } else if (grepl("Records", url)) {
    return(create_mock_response(mock_data_records))
  } else if (grepl("Metadata", url)) {
    return(create_mock_response(mock_data_metadata))
  } else if (grepl("Locations", url)) {
    return(create_mock_response(mock_data_locations))
  } else {
    stop("Unexpected URL")
  }
}

# Function to mock and test data fetching
fetch_and_test_data_mock <- function(fetch_function, qs, mock_data) {
  skip_if_not_installed("jsonlite")

  local_mocked_bindings(req_perform = mock_get,.package="httr2")
  local_mocked_bindings(resp_body_json = translate_mock_json,.package="httr2")

  result <- fetch_function(qs)
  expect_s3_class(result, "data.frame")
  df_mock_data <- dplyr::bind_rows(mock_data)
  expect_equal(ncol(result), ncol(df_mock_data))
  expect_equal(nrow(result), nrow(df_mock_data))
  expect_equal(result$Id, df_mock_data$Id)
}
