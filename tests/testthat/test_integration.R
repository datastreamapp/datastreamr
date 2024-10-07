library(testthat)
library(jsonlite)

source("test_helper.R")

test_that("fetch observations for location and DOI", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '406583' and DOI eq '10.25976/4mf6-k783'"
  )
  
  fetch_and_test_data(observations, qs)
})

test_that("fetch observations for DOI and all locations", {
  qs <- list(
    `$select` = "Id, DOI, LocationId, CharacteristicName, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/4mf6-k783'"
  )
  
  fetch_and_test_data(observations, qs)
})

test_that("fetch records for location and DOI", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "LocationId eq '5717' and DOI eq '10.25976/4mf6-k783'"
  )
  
  fetch_and_test_data(records, qs)
})

test_that("fetch records for DOI and all locations", {
  qs <- list(
    `$select` = "Id, DOI, DatasetName, MonitoringLocationID, MonitoringLocationName, MonitoringLocationLatitude, MonitoringLocationLongitude, MonitoringLocationHorizontalCoordinateReferenceSystem, MonitoringLocationHorizontalAccuracyMeasure, MonitoringLocationHorizontalAccuracyUnit, MonitoringLocationVerticalMeasure, MonitoringLocationVerticalUnit, MonitoringLocationType, ActivityType, ActivityMediaName, ActivityStartDate, ActivityStartTime, ActivityEndDate, ActivityEndTime, ActivityDepthHeightMeasure, ActivityDepthHeightUnit, SampleCollectionEquipmentName, CharacteristicName, MethodSpeciation, ResultSampleFraction, ResultValue, ResultUnit, ResultValueType, ResultDetectionCondition, ResultDetectionQuantitationLimitMeasure, ResultDetectionQuantitationLimitUnit, ResultDetectionQuantitationLimitType, ResultStatusID, ResultComment, ResultAnalyticalMethodID, ResultAnalyticalMethodContext, ResultAnalyticalMethodName, AnalysisStartDate, AnalysisStartTime, AnalysisStartTimeZone, LaboratoryName, LaboratorySampleID",
    `$filter` = "DOI eq '10.25976/4mf6-k783'"
  )
  
  fetch_and_test_data(records, qs)
})

test_that("fetch location by Id", {
  qs <- list(
    `$select` = "Id, DOI, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "LocationId eq '5717'",
    `$top` = "10"
  )
  
  fetch_and_test_data(locations, qs)
})

test_that("fetch location for DOI with top", {
  qs <- list(
    `$select` = "Id, DOI, Name, Latitude, Longitude, HorizontalCoordinateReferenceSystem, HorizontalAccuracyMeasure, HorizontalAccuracyUnit, VerticalMeasure, VerticalUnit, MonitoringLocationType, LatitudeNormalized, LongitudeNormalized",
    `$filter` = "DOI eq '10.25976/4mf6-k783'",
    `$top` = "10"
  )
  
  fetch_and_test_data(locations, qs)
})

test_that("fetch metadata by Id", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "Id eq '0456bedd-cd0c-44ce-8f8d-da0afbb6694b'"
  )
  
  fetch_and_test_data(metadata, qs)
})

test_that("fetch metadata for DOI with top", {
  qs <- list(
    `$select` = "Id, DOI, Version, DatasetName, DataStewardEmail, DataCollectionOrganization, DataUploadOrganization, ProgressCode, MaintenanceFrequencyCode, Abstract, DataCollectionInformation, DataProcessing, FundingSources, DataSourceURL, OtherDataSources, Citation, Licence, Disclaimer, TopicCategoryCode, Keywords, CreateTimestamp, PublishedTimestamp",
    `$filter` = "DOI eq '10.25976/4mf6-k783'",
    `$top` = "10"
  )
  
  fetch_and_test_data(metadata, qs)
})

test_that("fetch All metadata", {

  qs <- list()

  fetch_and_test_data(metadata, qs)
})


test_that("fetch Metadata count", {
  
  qs <- list(
    `$count` = "true"
  )

  fetch_and_test_data(metadata, qs)
})

############# Tests from readme

# test_that("Pull all metadata for all datasets in the Atlantic DS Hub", {
# qs <- list(
#     `$select` = "",
#     `$filter` = ""
#   )
  
#   fetch_and_test_data(metadata, qs)
# })


# test_that("Pull all metadata for all datasets in BC", {
#   qs <- list(
#     `$filter` = "RegionId eq 'admin.4.ca.bc'"
#   )
#   fetch_and_test_data(metadata, qs)
# })


# test_that("Pull only the DOI's and contact emails for all datasets in the Great Lakes Hub", {
# qs <- list(
#     `$select` = "DOI, DataStewardEmail",
#     `$filter` = "RegionId eq 'hub.greatlakes'"
#   )
  
#   fetch_and_test_data(metadata, qs)
# })


# test_that("Pull all location information for sites in Ontario )", {
#   qs <- list(
#     `$filter` = "RegionId eq 'admin.4.ca.on'",
#     `$top` = "1000"
#   )
  
#   fetch_and_test_data(locations, qs)
# })


# test_that("Pull the site names and lat/lon coordinates for a particular dataset)", {
# qs <- list(
#     `$select` = "Name, Latitude, Longitude",
#     `$filter` = "DOI eq '10.25976/1q5q-zy55'"
#   )
  
#   fetch_and_test_data(locations, qs)
# })

# test_that("Pull all ph data available in the Atlantic DS Hub (only pulling top 1000)", {
#   qs <- list(
#     `$filter` = "RegionId eq 'hub.atlantic' and CharacteristicName eq 'pH'",
#     `$top` = "1000"
#   )
  
#   fetch_and_test_data(records, qs)
# })


# test_that("only select desired columns", {
#   qs <- list(
#     `$select` = "DOI, DatasetName, MonitoringLocationName, MonitoringLocationLatitude",
#     `$filter` = "RegionId eq 'hub.atlantic' and CharacteristicName eq 'pH'",
#     `$top` = "1000"
#   )
  
#   fetch_and_test_data(records, qs)
# })

# test_that("pull data before 2015 ", {
#   qs <- list(
#     `$select` = "DOI, DatasetName, MonitoringLocationName, MonitoringLocationLatitude",
#     `$filter` = "RegionId eq 'hub.atlantic' and CharacteristicName eq 'pH' and ActivityStartYear lt '2015'",
#     `$top` = "1000"
#   )
  
#   fetch_and_test_data(records, qs)
# })

# test_that("Try observations", {
#   qs <- list(
#     `$select` = "ResultValue",
#     `$filter` = "CharacteristicName eq 'pH' and ActivityStartYear gt '2019'",
#     `$top` = "1000"
#   )
  
#   fetch_and_test_data(observations, qs)
# })

# test_that("Use the count filter", {
#   qs <- list(
#     `$select` = "ResultValue",
#     `$filter` = "RegionId eq 'hub.atlantic' and CharacteristicName eq 'Ammonia' and ActivityStartYear gt '2019'",
#     `$count` = "true"
#   )
  
#   fetch_and_test_data(observations, qs)
# })