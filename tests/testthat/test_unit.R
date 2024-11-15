# Observations tests
test_that("fetch observations for location and DOI with mock data", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '406583' and DOI eq '10.25976/abcd-1234'"
  )

  fetch_and_test_data_mock(observations, qs, mock_data_observations)
})

test_that("fetch observations for DOI and all locations with mock data", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/abcd-1234'"
  )

  fetch_and_test_data_mock(observations, qs, mock_data_observations)
})

test_that("fetch records for location and DOI with mock data", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '5717' and DOI eq '10.25976/abcd-1234'"
  )

  fetch_and_test_data_mock(records, qs, mock_data_records)
})

test_that("fetch records for DOI and all locations with mock data", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/abcd-1234'"
  )

  fetch_and_test_data_mock(records, qs, mock_data_records)
})

test_that("fetch location by Id with mock data", {
  qs <- list(
    `$select` = "Id, DOI, NameId, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "LocationId eq '5717'",
    `$top` = "10"
  )

  fetch_and_test_data_mock(locations, qs, mock_data_locations)
})

test_that("fetch location for DOI with top and mock data", {
  qs <- list(
    `$select` = "Id, DOI, NameId, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "DOI eq '10.25976/abcd-1234'",
    `$top` = "10"
  )

  fetch_and_test_data_mock(locations, qs, mock_data_locations)
})

test_that("fetch metadata by Id with mock data", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "Id eq '0456bedd-cd0c-44ce-8f8d-da0afbb6694b'"
  )

  fetch_and_test_data_mock(metadata, qs, mock_data_metadata)
})

test_that("fetch metadata for DOI with top and mock data", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "DOI eq '10.25976/abcd-1234'",
    `$top` = "10"
  )

  fetch_and_test_data_mock(metadata, qs, mock_data_metadata)
})
