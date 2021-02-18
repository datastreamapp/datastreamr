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

## Allowed Values
The allowed values for the functions are:

- **ds_metadata**
  - Select: `Id`, `Name`, `Abstract`, `Citation`, `DataStewardEmail`, `DataCollectionOrganization`, `DataCollectionInformation`, `DataProcessing`, `DataUploadOrganization`, `DataSources`, `FundingSources`, `License`, `Disclaimer`, `Doi`, `Iso`, `Keywords`, `VerifyTimestamp`, `ApproveTimestamp`, `Filesize`, `Version`, `CreateTimestamp`, `ProgramName`
  - Filter: `Id`, `Name`, `CreateTimestamp`, `CharacteristicName`, `RegionId`
  - Orderby: `Name`, `CreateTimestamp`
- **ds_locations**
  - Select: `Id`, `Name`, `Latitude`, `Longitude`, `HorizontalCoordinateReferenceSystem`,   `Type`,`Waterbody`
  - Filter: `Id`, `Name`, `CharacteristicName`, `RegionId`
  - Orderby: `Name`
- **ds_observations**
  - Select: `Id`, `DatasetId`, `LocationId`, `ActivityType`, `ActivityMediaName`, `ActivityStartTimestamp`, `ActivityEndTimestamp`, `ActivityDepthHeightMeasure`, `ActivityDepthHeightUnit`, `SampleCollectionEquipmentName`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`, `ResultValue`, `ResultUnit`, `ResultValueType`, `ResultDetectionCondition`, `ResultDetectionQuantitationLimitUnit`, `ResultDetectionQuantitationLimitMeasure`, `ResultDetectionQuantitationLimitType`, `ResultStatusId`, `ResultComment`, `ResultAnalyticalMethodId`, `ResultAnalyticalMethodContext`, `ResultAnalyticalMethodName`, `AnalysisStartTimestamp`, `LaboratoryName`, `LaboratorySampleId`
  - Filter: `DatasetId`, `LocationId`, `ActivityStartTimestamp`, `ActivityType`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`, `RegionId`
  - Orderby: `ActivityStartTimestamp`, `CharacteristicName`, `MethodSpeciation`, `SampleFraction`

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
  - Available filters: =, <, >, <=, >=
  - Grouping: filter=c("CharacteristicName='Dissolved oxygen saturation'")
  - Temporal: filter=c("CreateTimestamp>'2020-03-23'", "CreateTimestamp<'2020-03-25'")
  - Spatial: filter=c(RegionId='hub.atlantic')
      - RegionId Values (We're actively working on these, values will change):
        - Partner Hubs: hub.{atlantic,lakewinnipeg,mackenzie}
        - Countries: admin.2.{ca}
        - Provinces/Territories/States: admin.4.ca-{ab,bc,...,yt}
        - Watersheds/Drainage Areas: watershed.oda.*,watershed.mda.*,watershed.sda.*,watershed.ssda.* (Future)
        - Water: waterbody.marine.*, waterbody.greatlakes.*, waterbody.lakes.*, waterbody.rivers.* (Future)
        - Bounding box $filter=LongitudeNormalized gt '-102.01' and LongitudeNormalized lt '-88.99' and LatitudeNormalized gt '49' and LatitudeNormalized lt '60'
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
