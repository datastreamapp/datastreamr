<h1 align="center">
  <img src="https://raw.githubusercontent.com/gordonfn/datastreamr/master/docs/images/datastream.svg" alt="DataStream Logo" width="400">
  <br/>
  DataStream R Package
  <br/>
  <br/>
</h1>


This tool is useful for those who want to extract large volumes of data from <a href="https://datastream.org">DataStream</a>. This R package allows users to call to the  DataStream  <a href="https://github.com/datastreamapp/api-docs">Public API</a> using built-in R functions and specific search queries. The package includes several functions which accept a selection of filtering queries and then return a dataframe with the desired data from DataStream. 

**You might use this tool, for example, if you:**
*  Want to download all available DataStream pH data in Ontario
*  Want to count how many sites in New Brunswick have cesium data on DataStream

##
  
<h3 align="center">
 <a href="https://docs.google.com/forms/d/1SjPVeblz2QFaghpiBZPZKOVNKXgw5UMnAtJLJS1tQYI">Request an API Token</a>
 </h3>
<p align="center">
<h align="center">
To have full API permissions, users must request an API token which is required to call to the API 
<p align="center">


## Installation
To install the most recent version in R:

```R
# install.packages("devtools")
devtools::install_github("datastreamapp/datastreamr")
```

## Attribution/Citation
Thank you ahead of time for using this data responsibly and providing the appropriate citations when necessary when presenting work to external parties. These dataset citations must be accompanied by a link to the DOI (https://doi.org/{value}). The dataset licence, citation, and DOI can be retrieved from the `/Metadata` endpoint.

### Licence representations
The API returns the URL for a dataset's licence, these should be mapped to the full licence name with a link to the full licence details.
- `Attribution Licence`: 
  - EN: Attribution Licence (ODC-By) v1.0
  - FR: Licence d'attribution (ODC-By) v1.0
  - URL: https://opendatacommons.org/licenses/by/1-0/
- `Public Domain Dedication and Licence`: 
  - EN: Public Domain Dedication and Licence (ODC-PDDL) v1.0
  - FR: Dédicace et licence du domaine public (ODC-PDDL) v1.0
  - URL: https://opendatacommons.org/licenses/pddl/1-0/
- `Open Government Licence`:
  - EN: Open Government Licence (OGL)
  - FR: Licence du gouvernement ouvert (OGL)
  - URL: Dataset-dependent, entered by data provider (eg. https://open.canada.ca/en/open-government-licence-canada) 

## The Functions 
The following functions are used to call to the DataStream API and pull desired information.  

### metadata():  
**Description** 
 <br/>
Pulls only the dataset level metadata information including dataset name, citation, licence, abstract, etc. 
 <br/>
  <br/>
**Usage**
```R
metadata( 
  list(
    `$select` = NULL,
    `$filter` = NULL,
    `$top` = NULL,
    `$count` = "false"
  )
)
```

  
### locations():  
**Description** 
 <br/>
Pulls only the location data including Location ID, Location Name, Latitude, and Longitude.
 <br/>
  <br/>
**Usage**
```R
locations( 
  list(
    `$select` = NULL,
    `$filter` = NULL,
    `$top` = NULL,
    `$count` = "false"
  )
)
```
  
### records(): 
**Description** 
 <br/>
Pulls data formatted the same as the downloaded DataStream CSV’s including all columns listed in the DataStream <a href="https://github.com/datastreamapp/schema">schema</a> .
 <br/>
  <br/>
  **Usage**
* This function will take longer than `observations`, but provides all available columns in one request. <br/>
* Use this function if you aim to pull all location and parameter data in one call  <br/>

```R
records( 
  list(
    `$select` = NULL,
    `$filter` = NULL,
    `$top` = NULL,
    `$count` = "false"
  )
)
```
  
### observations():  
**Description** 
 <br/>
Pulls data in a condensed format that must be joined with other endpoints to create a full dataset with all the DataStream columns. Specifically, location rows are not pulled, instead `LocationId` is pulled for each observation and then can be used in combination with `locations()`. 
 <br/>
  <br/>
  **Usage**
* This function will be quicker than `records`, but if location specifics are needed, needs to be paired with `locations()` <br/>
* Use this function either if you are uninterested in specific location coordinates, or in combination with `locations()` when you plan to pull millions of rows of data <br/>

```R
observations( 
  list(
    `$select` = NULL,
    `$filter` = NULL,
    `$top` = NULL,
    `$count` = "false"
  )
)
```

## Function Inputs 
All of the functions above accept query parameters. The ones supported are:  
##
- **api_token:** *A character string containing your unique API key* <br/>

  - Click  <a href="https://docs.google.com/forms/d/1SjPVeblz2QFaghpiBZPZKOVNKXgw5UMnAtJLJS1tQYI">here</a> to request an api token <br/>
##
- **select:** *A list of allowable columns to return* <br/>

  - Fields to be selected are entered as a list.
  - Example: `select="DatasetName,Abstract"`
  - Default: All columns available.
 
$`\color{blue}{\text{Note}}`$: refer to **Allowed Values** section below for available select fields

##
 - **filter:** *A list of conditions to filter by*  <br/>
 
   - Available operators: 
    - eq: Used for exact matches.
    - ne: Used for not equal to.
    - gt: Used for greater than.
    - lt: Used for less than.
    - ge: Used for greater than or equal to.
    - le: Used for less than or equal to.
    - and: Used to combine multiple filters with an “and” condition.
   - Grouping: `filter="CharacteristicName eq 'Dissolved oxygen saturation' and DOI eq '10.25976/n02z-mm23'"`
   - Temporal (Dataset creation): `filter="CreateTimestamp gt 2020-03-23"`
   - Temporal (Data date-range): `filter="ActivityStartYear gt '2019'"`
   - Spatial: `filter=RegionId eq 'hub.atlantic'`
        - `RegionId` Values (these values are subject to change):
        - **DataStream Hubs**: `hub.{atlantic,lakewinnipeg,mackenzie,greatlakes,pacific }`
        - **Countries**: `admin.2.{ca}`
        - **Provinces/Territories**: `admin.4.ca.{ab,bc,mb,nb,nl,ns,nt,nu,on,pe,qc,sk,yt}`
          
$`\color{blue}{\text{Note}}`$: refer to **Allowed Values** section below for available filter fields
    
##
- **top:**  <br/>

  - Maximum: 10000
  - Example: `top=10`
##
- **count:** *When TRUE, returns number of observations rather than the data itself* <br/>

  - Return only the count for the request. When the value is large enough it becomes an estimate (~0.0005% accurate)
  - Example: `count=true`
  - Default: `false`
  
  ### Performance Tips
    - Use `select` to request only the parameters you need. This will decrease the amount of data needed to process and transfer.

  
## Allowed Values
The allowed `select` and `filter` options for each of the functions are listed **<a href="https://github.com/datastreamapp/api-docs?tab=readme-ov-file#endpoints">HERE</a>**. 



$`\color{green}{\text{Note:}}`$ When using the `filter` field, a useful resource is the "allowed values" tab of our <a href="https://datastreamorg.sharepoint.com/:x:/s/Datastream/EaqcNGHom7BFlRi6bRY4VDoBy6ECq6v3bbUyeb0B3S3HGg?e=75aBTl"> upload template </a>. This will give you available strings for: 
* `MonitoringLocationType`
* `ActivityMediaName`
* `CharacteristicName`

  ##

## Authentication
By default the environment variable "DATASTREAM_API_KEY" is used for setting the API key. The API key can also be set by:
```R
setAPIKey('xxxxxxxxxx') 
```

## Full examples

## Locations

**Get Locations from a dataset**
```R
qs <- list(
    `$select` = "Id,DOI,Name,Latitude,Longitude",
    `$filter` = "DOI eq '10.25976/xxxx-xx00'",
    `$top` = 10000
  )
result = locations(qs)
```

**Get Locations from multiple datasets**
```R
qs <- list(
    `$select` = "Id,DOI,Name,Latitude,Longitude",
    `$filter` = "DOI in ('10.25976/xxxx-xx00', '10.25976/xxxx-xx11', '10.25976/xxxx-xx22')",
    `$top` = 10000)
result = locations(qs)
```

## Observations

**Get `Temperature` and `pH` observations from multiple datasets**

```R
qs <- list(
    `$select` = "DOI,ActivityType,ActivityMediaName,ActivityStartDate,ActivityStartTime,SampleCollectionEquipmentName,CharacteristicName,MethodSpeciation,ResultSampleFraction,ResultValue,ResultUnit,ResultValueType",
    `$filter` = "DOI in ('10.25976/xxxx-xx00', '10.25976/xxxx-xx11', '10.25976/xxxx-xx22') and CharacteristicName in ('Temperature, water', 'pH')",
    `$top` = 10000)
result = observations(qs)
```


## Records
**Get select fields from a dataset**

```R
qs <- list(
    `$select` = "DOI,ActivityType,ActivityMediaName,ActivityStartDate,ActivityStartTime,SampleCollectionEquipmentName,CharacteristicName,MethodSpeciation,ResultSampleFraction,ResultValue,ResultUnit,ResultValueType",
    `$filter` = "DOI eq '10.25976/xxxx-xx00'",
    `$top` = 10000)
result = records(qs)
```

## Metadata
**Get the `DOI`, `Version`, and `DatasetName` for a dataset**
```R
qs <- list(
    `$select` = "DOI,Version,DatasetName",
    `$filter` = "DOI eq '10.25976/xxxx-xx00'",
    `$top` = 10000)
result = metadata(qs)
```

## Get Result Count
```R
qs <- list(
    `$filter` = "DOI eq '10.25976/xxxx-xx00'",
    `$count` = "true")
count = observations(qs)
```


## Tests
Dockerfile is provided to run the unit tests and the integration tests. To build the docker image for running tests and other debugging purposes you can run: 
```Bash
docker build -t datastreamr .
```

To run the unit tests:
```Bash
docker run --rm -e DATASTREAM_API_KEY=$(cat api_key.txt) datastreamr R -e "library(testthat); test_file('tests/testthat/test_unit.R')"
```

To run the integration tests:
```Bash
docker run --rm -e DATASTREAM_API_KEY=$(cat api_key.txt) datastreamr R -e "library(testthat); test_file('tests/testthat/test_integration.R')"
```
