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
  - Select: `Id`, `Name`, `Abstract`, `Citation`, `DataStewardEmail`, `DataCollectionOrganization`, `DataCollectionInformation`, `DataProcessing`, `DataUploadOrganization`, `DataSources`, `FundingSources`, `License`, `Disclaimer`, `Doi`, `Iso`, `Keywords`, `VerifyTimestamp`, `ApproveTimestamp`, `Filesize`, `Version`, `CreateTimestamp`, `ProgramName`
  - Filter By: `Id`, `Name`, `CreateTimestamp`, `CharacteristicName`, `RegionId`
  - Order By: `Name`, `CreateTimestamp`
- **ds_locations**
  - Select: `Id`, `Name`, `Latitude`, `Longitude`, `HorizontalCoordinateReferenceSystem`,   `Type`,`Waterbody`
  - Filter By: `Id`, `Name`, `CharacteristicName`, `RegionId`
  - Order By: `Name`
- **ds_observations**
  - Select: `Id`, `DatasetId`, `LocationId`, `ActivityType`, `ActivityMediaName`, `ActivityStartTimestamp`, `ActivityEndTimestamp`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitType`, `ResultStatusId`, `ResultComment`, `ResultAnalyticalMethodId`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartTimestamp`, `LaboratoryName`, `LaboratorySampleId`
  - Filter By: `DatasetId`, `LocationId`, `ActivityStartTimestamp`, `ActivityType`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`, `RegionId`
  - Order By: `ActivityStartTimestamp`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`
- **ds_records**
  - Select By: `Id`, `DatasetName`, `MonitoringLocationID`, `MonitoringLocationName`, `MonitoringLocationLatitude`, `MonitoringLocationLongitude`, `MonitoringLocationHorizontalCoordinateReferenceSystem`, `MonitoringLocationHorizontalAccuracyMeasure`, `MonitoringLocationHorizontalAccuracyUnit`, `MonitoringLocationVerticalMeasure`, `MonitoringLocationVerticalUnit`, `MonitoringLocationType`, `ActivityType`, `ActivityMediaName`, `ActivityStartDate`, `ActivityStartTime`, `ActivityEndDate`, `ActivityEndTime`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `ResultSampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitType`, `ResultStatusID`, `ResultComment`, `ResultAnalyticalMethodID`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartDate`, `AnalysisStartTime`, `AnalysisStartTimeZone`, `LaboratoryName`, `LaboratorySampleID`
  - Filter By: `Id`, `DatasetName`, `MonitoringLocationID`, `MonitoringLocationName`, `MonitoringLocationLatitude`, `MonitoringLocationLongitude`, `MonitoringLocationHorizontalCoordinateReferenceSystem`, `MonitoringLocationHorizontalAccuracyMeasure`, `MonitoringLocationHorizontalAccuracyUnit`, `MonitoringLocationVerticalMeasure`, `MonitoringLocationVerticalUnit`, `MonitoringLocationType`, `ActivityType`, `ActivityMediaName`, `ActivityStartDate`, `ActivityStartTime`, `ActivityEndDate`, `ActivityEndTime`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `ResultSampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitType`, `ResultStatusID`, `ResultComment`, `ResultAnalyticalMethodID`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartDate`, `AnalysisStartTime`, `AnalysisStartTimeZone`, `LaboratoryName`, `LaboratorySampleID`, `RegionId`
  - Order By: `DatasetName`, `ActivityStartDate`, `ActivityStartTime`, `ActivityEndDate`, `ActivityEndTime`, `CharacteristicName`

The functions accepts certain query parameters. The ones supported are:
- **select**
  - Fields to be selected are entered as a list.
  - Example: select=c("Name","Abstract")
  - Default: All columns available.
- **orderby**
  - Fields to order by are entered comma delimited.
  - Example: orderby=c("Name","CreateTimestamp")
- **top**
  - Maximum: 10000
  - Example: top=10
- **filter**
  - Available filters: =, <, >, <=, >=, !=
  - Grouping: filter=c("CharacteristicName=Dissolved oxygen saturation")
  - Temporal: filter=c("CreateTimestamp>2020-03-23", "CreateTimestamp<2020-03-25")
  - Spatial: filter=c(RegionId=hub.atlantic)
      - RegionId Values (We're actively working on these, values will change):
        - Partner Hubs: hub.{atlantic,lakewinnipeg,mackenzie}
        - Countries: admin.2.{ca}
        - Provinces/Territories/States: admin.4.ca-{ab,bc,...,yt}
        - Watersheds/Drainage Areas: watershed.oda.*,watershed.mda.*,watershed.sda.*,watershed.ssda.* (Future)
        - Water: waterbody.marine.*, waterbody.greatlakes.*, waterbody.lakes.*, waterbody.rivers.* (Future)
        - Bounding box $filter=LongitudeNormalized > '-102.01' and LongitudeNormalized < '-88.99' and LatitudeNormalized > '49' and LatitudeNormalized < '60'
- **count**
  - Return only the count for the request
  - Example: count=TRUE
  - Default: FALSE
  
  ### Performance Tips
- Using select to request only the parameters you need will decrease the amount of data needed to process and transfer.
- Not using orderby will improve response times.

### Contributors
- [Patrick LeClair](https://github.com/patrickleclair-GORDONFN)

## References
- 

<div align="center">
  <a href="http://gordonfoundation.ca"><img src="https://raw.githubusercontent.com/gordonfn/datastreamr/master/docs/images/the-gordon-foundation.svg" alt="The Gordon Foundation Logo" width="200"></a>
</div>
