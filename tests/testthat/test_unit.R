library(testthat)
library(httptest)
library(jsonlite)

source("test_helper.R")

# Mock data for the tests
mock_data_observations <- list(
  list(Id = "1", DOI = "10.25976/abcd-1234", LocationId = "406583", CharacteristicName = "pH", ActivityType = "Sample", ActivityMediaName = "Water", ActivityStartDate = "2021-01-01", ActivityStartTime = "12:00", ActivityEndDate = "2021-01-01", ActivityEndTime = "13:00", ActivityDepthHeightMeasure = 5.0, ActivityDepthHeightUnit = "m", SampleCollectionEquipmentName = "Bottle", MethodSpeciation = "None", ResultSampleFraction = "Total", ResultValue = 7.0, ResultUnit = "pH units", ResultValueType = "Actual", ResultDetectionCondition = "None", ResultDetectionQuantitationLimitUnit = "mg/L", ResultDetectionQuantitationLimitMeasure = 0.1, ResultDetectionQuantitationLimitType = "DL", ResultStatusID = "Final", ResultComment = "None", ResultAnalyticalMethodID = "Method1", ResultAnalyticalMethodContext = "Context1", ResultAnalyticalMethodName = "Method Name", AnalysisStartDate = "2021-01-02", AnalysisStartTime = "14:00", AnalysisStartTimeZone = "UTC", LaboratoryName = "Lab1", LaboratorySampleID = "Sample1")
)

mock_data_records <- list(
  list(Id = "1", DOI = "10.25976/abcd-1234", DatasetName = "Dataset1", MonitoringLocationID = "5717", MonitoringLocationName = "Location1", MonitoringLocationLatitude = 40.7128, MonitoringLocationLongitude = -74.0060, MonitoringLocationHorizontalCoordinateReferenceSystem = "WGS84", MonitoringLocationHorizontalAccuracyMeasure = 1.0, MonitoringLocationHorizontalAccuracyUnit = "m", MonitoringLocationVerticalMeasure = 10.0, MonitoringLocationVerticalUnit = "m", MonitoringLocationType = "Stream", ActivityType = "Sample", ActivityMediaName = "Water", ActivityStartDate = "2021-01-01", ActivityStartTime = "12:00", ActivityEndDate = "2021-01-01", ActivityEndTime = "13:00", ActivityDepthHeightMeasure = 5.0, ActivityDepthHeightUnit = "m", SampleCollectionEquipmentName = "Bottle", CharacteristicName = "pH", MethodSpeciation = "None", ResultSampleFraction = "Total", ResultValue = 7.0, ResultUnit = "pH units", ResultValueType = "Actual", ResultDetectionCondition = "None", ResultDetectionQuantitationLimitMeasure = 0.1, ResultDetectionQuantitationLimitUnit = "mg/L", ResultDetectionQuantitationLimitType = "DL", ResultStatusID = "Final", ResultComment = "None", ResultAnalyticalMethodID = "Method1", ResultAnalyticalMethodContext = "Context1", ResultAnalyticalMethodName = "Method Name", AnalysisStartDate = "2021-01-02", AnalysisStartTime = "14:00", AnalysisStartTimeZone = "UTC", LaboratoryName = "Lab1", LaboratorySampleID = "Sample1")
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
    Keywords = I(list("Keyword1", "Keyword2", "Keyword3", "Keyword4")), 
    CreateTimestamp = "2024-06-16T07:16:43.489Z", 
    PublishedTimestamp = "2024-06-19T07:16:43.488Z"
  )
)

mock_data_locations <- list(
  list(Id = "1", DOI = "10.25976/abcd-1234", NameId = "Name1", Name = "Location1", Latitude = 40.7128, Longitude = -74.0060, HorizontalCoordinateReferenceSystem = "WGS84", HorizontalAccuracyMeasure = 1.0, HorizontalAccuracyUnit = "m", VerticalMeasure = 10.0, VerticalUnit = "m", MonitoringLocationType = "Stream", LatitudeNormalized = 40.7128, LongitudeNormalized = -74.0060)
)

# Wrapper to convert the mock data to the same format as GET responses
create_mock_response <- function(data) {
  response <- list(
    status_code = 200,
    headers = list(`content-type` = "application/json"),
    content = charToRaw(jsonlite::toJSON(list(value = data), auto_unbox = TRUE))
  )
  class(response) <- "response"
  response
}

# Mock function to replace the actual GET call
mock_get <- function(url, ...) {
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
fetch_and_test_data <- function(fetch_function, qs, mock_data) {
  with_mock(
    `httr::GET` = mock_get,
    {
      result <- fetch_function(qs)
      expect_is(result, "data.frame")
      df_mock_data <- bind_rows(mock_data)
      expect_equal(nrow(result), nrow(df_mock_data))
      expect_equal(result$Id, df_mock_data$Id)
    }
  )
}

# Observations tests
test_that("fetch observations for location and DOI with mock data", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '406583' and DOI eq '10.25976/abcd-1234'"
  )
  
  fetch_and_test_data(observations, qs, mock_data_observations)
})

test_that("fetch observations for DOI and all locations with mock data", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/abcd-1234'"
  )
  
  fetch_and_test_data(observations, qs, mock_data_observations)
})

test_that("fetch records for location and DOI with mock data", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '5717' and DOI eq '10.25976/abcd-1234'"
  )
  
  fetch_and_test_data(records, qs, mock_data_records)
})

test_that("fetch records for DOI and all locations with mock data", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/abcd-1234'"
  )
  
  fetch_and_test_data(records, qs, mock_data_records)
})

test_that("fetch location by Id with mock data", {
  qs <- list(
    `$select` = "Id, DOI, NameId, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "LocationId eq '5717'",
    `$top` = "10"
  )
  
  fetch_and_test_data(locations, qs, mock_data_locations)
})

test_that("fetch location for DOI with top and mock data", {
  qs <- list(
    `$select` = "Id, DOI, NameId, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "DOI eq '10.25976/abcd-1234'",
    `$top` = "10"
  )
  
  fetch_and_test_data(locations, qs, mock_data_locations)
})

test_that("fetch metadata by Id with mock data", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "Id eq '0456bedd-cd0c-44ce-8f8d-da0afbb6694b'"
  )
  
  fetch_and_test_data(metadata, qs, mock_data_metadata)
})

test_that("fetch metadata for DOI with top and mock data", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "DOI eq '10.25976/abcd-1234'",
    `$top` = "10"
  )
  
  fetch_and_test_data(metadata, qs, mock_data_metadata)
})
