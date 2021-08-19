<h1 align="center">
  <img src="https://raw.githubusercontent.com/gordonfn/datastreamr/master/docs/images/datastream.svg" alt="DataStream Logo" width="400">
  <br/>
  DataStream R Package
  <br/>
  <br/>
</h1>

**A tool for downloading DataStream data**

Provided with a selection of queries, the following functions call to the DataStream Public API and return a dataframe with the desired information. 

## Installation
To install the most recent beta in R:

```R
# install.packages("devtools")
devtools::install_github("gordonfn/datastreamr")
```

## Attribution/Citation
Thank you ahead of time for using this data responsibly and providing the appropriate citations when necessary when being presented to external parties. These citations must be accompanied by a link to the DOI (https://doi.org/{value}). The licence, citation, and DOI can be retrieved from the `/Metadata` endpoint.

### Licence representations
The API returns an id for a licence, these should be mapped to their full names with a link to the full licence details.
- `odc-by`: 
  - EN: Attribution Licence (ODC-By) v1.0
  - FR: Licence d'attribution (ODC-By) v1.0
  - URL: https://opendatacommons.org/licenses/by/1-0/
- `odc-pddl`: 
  - EN: Public Domain Dedication and Licence (ODC-PDDL) v1.0
  - FR: Dédicace et licence du domaine public (ODC-PDDL) v1.0
  - URL: https://opendatacommons.org/licenses/pddl/1-0/
- `ogl`:
  - EN: Open Government Licence (OGL)
  - FR: Licence du gouvernement ouvert (OGL)
  - There is no url for `ogl`, show the full disclaimer and link in-line href.

## Allowed Values
The allowed values for the functions are:

- **ds_metadata**
  - Select: `DOI`, `Version`, `DatasetName`, `DataStewardEmail`, `DataCollectionOrganization`, `DataUploadOrganization`, `ProgressCode`, `MaintenanceFrequencyCode`, `Abstract`, `DataCollectionInformation`, `DataProcessing`, `FundingSources`, `DataSourceURL`, `OtherDataSources`, `Citation`,   `Licence`, `Disclaimer`, `TopicCategoryCode`, `Keywords`, `CreateTimestamp`
  - Filter By: `DOI`, `DatasetName`, `RegionId`, `Latitude`, `Longitude`, `LatitudeNormalized`, `LongitudeNormalized`, `CreateTimestamp`
  - Order By: `DatasetName`, `CreateTimestamp`
- **ds_locations**
  - Select: `Id`, `DOI`, `NameId`, `Name`, `Latitude`, `Longitude`, `HorizontalCoordinateReferenceSystem`, `HorizontalAccuracyMeasure`, `HorizontalAccuracyUnit`, `VerticalMeasure`, `VerticalUnit`, `Type`, `LatitudeNormalized`\*, `LongitudeNormalized`\*, `HorizontalCoordinateReferenceSystemNormalized`\*
  - Filter By: `Id`, `DOI`, `MonitoringLocationType`, `ActivityStartYear`, `ActivityMediaName`, `CharacteristicName`, `RegionId`, `Name`, `LatitudeNormalized`, `LongitudeNormalized`
  - Order By: `Id`, `Name`

  \* Normalized coordinates are in `WGS84` projection.

- **ds_observations**
  - Select: `Id`, `DOI`, `LocationId`, `ActivityType`, `ActivityStartDate`, `ActivityStartTime`, `ActivityEndDate`, `ActivityEndTime`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `ResultSampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitType`, `ResultStatusId`, `ResultComment`, `ResultAnalyticalMethodId`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartDate`, `AnalysisStartTime`, `AnalysisStartTimeZone`, `LaboratoryName`, `LaboratorySampleId`, `ActivityDepthHeightMeasureNormalized`, `ActivityDepthHeightUnitNormalized`, `ResultValueNormalized`, `ResultUnitNormalized`, `ResultDetectionQuantitationLimitMeasureNormalized`, `ResultDetectionQuantitationLimitUnitNormalized`, `CreateTimestamp`
  - Filter By: `DOI`, `MonitoringLocationType`, `ActivityStartYear`, `ActivityMediaName`, `CharacteristicName`, `RegionId`, `LocationId`, `LatitudeNormalized`, `LongitudeNormalized`
  - Order By: `Id`, `ActivityStartDate`, `ActivityStartTime`
- **ds_records**
  - Select By: `Id`, `DOI`, `DatasetName`, `MonitoringLocationID`, `MonitoringLocationName`, `MonitoringLocationLatitude`, `MonitoringLocationLongitude`, `MonitoringLocationHorizontalCoordinateReferenceSystem`, `MonitoringLocationHorizontalAccuracyMeasure`, `MonitoringLocationHorizontalAccuracyUnit`, `MonitoringLocationVerticalMeasure`, `MonitoringLocationVerticalUnit`, `MonitoringLocationType`, `ActivityType`, `ActivityMediaName`, `ActivityStartDate`, `ActivityStartTime`, `ActivityEndDate`, `ActivityEndTime`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `ResultSampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitType`, `ResultStatusID`, `ResultComment`, `ResultAnalyticalMethodID`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartDate`, `AnalysisStartTime`, `AnalysisStartTimeZone`, `LaboratoryName`, `LaboratorySampleID`
  - Filter By: `DOI`, `MonitoringLocationType`, `ActivityStartYear`, `ActivityMediaName`, `CharacteristicName`, `LocationId`
  - Order By: `Id`, `ActivityStartDate`, `ActivityStartTime`

The functions accepts certain query parameters. The ones supported are:
- **select**
  - Fields to be selected are entered as a list.
  - Example: `select=c("DatasetName","Abstract")`
  - Default: All columns available.
- **orderby**
  - Fields to order by are entered comma delimited.
  - Example: `orderby=c("DatasetName","CreateTimestamp")`
- **top**
  - Maximum: 10000
  - Example: `top=10`
- **filter**
  - Available filters: `=, <, >, <=, >=, !=`
  - Grouping: `filter=c("CharacteristicName=Dissolved oxygen saturation", "DOI='10.25976/n02z-mm23'")`
  - Temporal: `filter=c("CreateTimestamp>2020-03-23", "CreateTimestamp<2020-03-25")`
  - Spatial: `filter=c(RegionId=hub.atlantic)`
      - RegionId Values (these values are subject to change):
        - Partner Hubs: `hub.{atlantic,lakewinnipeg,mackenzie}`
        - Countries: `admin.2.{ca}`
        - Provinces/Territories/States: `admin.4.ca-{ab,bc,...,yt}`
        - Watersheds/Drainage Areas: `watershed.oda.*`,`watershed.mda.*`,`watershed.sda.*`,`watershed.ssda.*` (Future)
        - Water: `waterbody.marine.*`, `waterbody.greatlakes.*`, `waterbody.lakes.*`, `waterbody.rivers.*` (Future)
        - Bounding box: `filter=c("LongitudeNormalized>'-102.01'", "LongitudeNormalized<'-88.99'", "LatitudeNormalized>'49'", "LatitudeNormalized<'60'"`
- **count**
  - Return only the count for the request. When the value is large enough it becomes an estimate (~0.0005% accurate)
  - Example: `count=TRUE`
  - Default: `FALSE`
- **skip**
  - Example: `skip=10`
- **skiptoken**
  - Return the next items after the skipped token, cannot be paired with `orderby`
  - Example: `skiptoken=Id:1234`
  ### Performance Tips
- Using select to request only the parameters you need will decrease the amount of data needed to process and transfer.
- Not using orderby will improve response times.

### Performance Tips
- Using `select` to request only the parameters you need will decrease the amount of data needed to be transfer.
- Using large `skip` values can be slow (it's a database thing), slicing your data by `GeometryId` and/or `CharacteristicName` will help prevent this.
- Don't use `orderby` unless you plan to pull a smaller number of results.

## Full examples
Get the citation and licence for a dataset:
```R
ds_metadata(api_token,filter=c("DOI='10.25976/1q5q-zy55'"), select=c("DOI","DatasetName","Licence","Citation","Version"))
```

Get all `pH` observations in `Alberta`:
```R
ds_records(api_token,filter=c("CharacteristicName='pH'", "RegionId='admin.4.ca-ab'"))
```

### Contributors
- [Patrick LeClair](https://github.com/patrickleclair-GORDONFN)

## References
- 

<div align="center">
  <a href="http://gordonfoundation.ca"><img src="https://raw.githubusercontent.com/gordonfn/datastreamr/master/docs/images/the-gordon-foundation.svg" alt="The Gordon Foundation Logo" width="200"></a>
</div>
