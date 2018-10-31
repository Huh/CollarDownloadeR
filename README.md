# CollarDownloadeR

_Given that we are working on the new collar package we are going to rename this package to collarfetchr for consistency and searchability.  Phasing out this package is in name only.  The package will continue to focus on all data reading capabilities required when working with collar data.  The new package can be found at https://github.com/Huh/collarfetchr_

A package to retrieve collar data from manufacturer's websites

This is very much a work in progress, but is being used by some collaborators.

### Companies
- [ATS](https://atstrack.com/)
- [Cell Track Tech](https://www.celltracktech.com/)
- [Vectronics](https://www.vectronic-aerospace.com/)

While the framework is in place to call the Vectronics API, the API is perhaps
not ready for production use.  I am in touch with the developers at Vectronics 
and will update this site as new information becomes available.

### In Progress
- [Lotek](http://www.lotek.com/)
At this time the Lotek website represents a significant undertaking to web 
scrape and the company has expressed that they have no interest in developing 
an API to allow easier access to your data.  For these reasons I will pursue 
Lotek as time allows, but it is not a priority.

## ATS example 
Using your login credentials we use web scraping to retrieve data from the ATS website.  The buttn_nm argument refers to the button that you would normally click to download data.  The button has a name that can be retrieved from the html of the website.  In this case we leave the bttn_nm NULL, which will download all the data.  This example will not run without actual credentials being passed to the function.

```R
my_data <- scrape_ats(bttn_nm = NULL, usr = "my_name", pwd = "my_secret")
```

## Cell Track Tech example
In this example the data are stored in tables that are linked within the website.  The website also presents the information in a multiple page table that must be navigated.  Leaving the last argument NULL will cause the function to navigate through all pages of the table and retrieve all the data tables that are found.  If only a data from a particular page is required then the user may pass the page number as the last argument.  A simple call would look like:

```R
my_data <- scrape_celltrack("my_name", "my_secret", NULL)
```

## Vectronics - Now functioning!
Thankfully Vectronics is quite forward thinking when it comes to data access.  They have developed an API or Application Programming Interface, which means that we can write code that retrieves data from their servers, cool!  To use the API we need to build a url like www.google.com, but in this case several special values are included to tell the server which data we desire.  The primary components of the url that we need to build are the base address, collar id, collar key, data type and one of start_date or after_data_id.  Once we have assembled these components we can call the api and have it return our data.

The two least intuitive parameters allow the user to only download data after some data id or date.  This should be helpful for those doing weekly downloads as it will not require the user to download every fix each time they retrieve data.  Note that one of start date or data id is required when calling the API.

```R
#  Get collar IDs - fake directory inserted to show call
ids <- cdr_get_id_from_key("C:/Temp/vec_keys")

#  Get collar keys
keys <- cdr_get_keys("C:/Temp/vec_keys")

#  Build url from base url, collar IDs, collar keys and data type
url <- cdr_build_vec_urls(
 base_url = NULL,
 collar_id = ids,
 collar_key = keys,
 type = "act"
)

# Call API - This will not work without a valid key and collar id
my_data <- cdr_call_vec_api(url)

#  Get collar IDs - fake directory inserted to show call
data_dir <- "C:/Temp/vec_keys"

ids <- cdr_get_id_from_key(data_dir)
> keys <- cdr_get_keys(data_dir)
> length(ids)
[1] 7
> length(keys)
[1] 7

#  Get GPS data from one collar after January 01, 2017
id <- ids[1]
key <- keys[1]

#  By date
url_1 <- cdr_build_vec_url(
  base_url = NULL,
  collar_id = id,
  collar_key = key,
  type = "gps",
  after_data_id = NULL,
  start_date = "2017-01-01T00:00:00"
)

#  Get data from the same collar after data ID 63091567
url_2 <- cdr_build_vec_url(
  base_url = NULL,
  collar_id = id,
  collar_key = key,
  type = "gps",
  after_data_id = 63091567,
  start_date = NULL
)

#  Call the api for the single url built using date
gps_dat_1 <- cdr_call_vec_api(url_1)

gps_dat_1 %>% dplyr::slice(1:2)
# A tibble: 2 x 46
  idPosition idCollar acquisitionTime scts  originCode   ecefX   ecefY  ecefZ latitude longitude height   dop idFixType positionError satCount ch01SatId ch01SatCnr
       <int>    <int> <chr>           <chr> <chr>        <int>   <int>  <int>    <dbl>     <dbl>  <int> <dbl>     <int> <lgl>            <int> <lgl>     <lgl>     
1   63091567    238   2018-09-27T01:~ 2018~ G          -1.86e6 -4.16e6 4.45e6     44.5     -114.   1935   5.6         5 NA                   0 NA        NA        
2   63089819    238   2018-09-27T01:~ 2018~ G          -1.86e6 -4.16e6 4.45e6     44.5     -114.   1910   6.2         5 NA                   0 NA        NA        
# ... with 29 more variables: ch02SatId <lgl>, ch02SatCnr <lgl>, ch03SatId <lgl>, ch03SatCnr <lgl>, ch04SatId <lgl>, ch04SatCnr <lgl>, ch05SatId <lgl>,
#   ch05SatCnr <lgl>, ch06SatId <lgl>, ch06SatCnr <lgl>, ch07SatId <lgl>, ch07SatCnr <lgl>, ch08SatId <lgl>, ch08SatCnr <lgl>, ch09SatId <lgl>, ch09SatCnr <lgl>,
#   ch10SatId <lgl>, ch10SatCnr <lgl>, ch11SatId <lgl>, ch11SatCnr <lgl>, ch12SatId <lgl>, ch12SatCnr <lgl>, idMortalityStatus <int>, activity <int>,
#   mainVoltage <dbl>, backupVoltage <dbl>, temperature <dbl>, transformedX <lgl>, transformedY <lgl>

#  Call the api for the single url built using data ID
gps_dat_2 <- cdr_call_vec_api(url_1)

gps_dat_2 %>% dplyr::slice(1:2)
# A tibble: 2 x 46
  idPosition idCollar acquisitionTime scts  originCode   ecefX   ecefY  ecefZ latitude longitude height   dop idFixType positionError satCount ch01SatId ch01SatCnr
       <int>    <int> <chr>           <chr> <chr>        <int>   <int>  <int>    <dbl>     <dbl>  <int> <dbl>     <int> <lgl>            <int> <lgl>     <lgl>     
1   57879496    238   2018-06-19T00:~ 2018~ G          -1.86e6 -4.15e6 4.45e6     44.6     -114.   1737   1.8         5 NA                   0 NA        NA        
2   57908796    238   2018-06-19T13:~ 2018~ G          -1.87e6 -4.15e6 4.45e6     44.6     -114.   1637   2.8         5 NA                   0 NA        NA        
# ... with 29 more variables: ch02SatId <lgl>, ch02SatCnr <lgl>, ch03SatId <lgl>, ch03SatCnr <lgl>, ch04SatId <lgl>, ch04SatCnr <lgl>, ch05SatId <lgl>,
#   ch05SatCnr <lgl>, ch06SatId <lgl>, ch06SatCnr <lgl>, ch07SatId <lgl>, ch07SatCnr <lgl>, ch08SatId <lgl>, ch08SatCnr <lgl>, ch09SatId <lgl>, ch09SatCnr <lgl>,
#   ch10SatId <lgl>, ch10SatCnr <lgl>, ch11SatId <lgl>, ch11SatCnr <lgl>, ch12SatId <lgl>, ch12SatCnr <lgl>, idMortalityStatus <int>, activity <int>,
#   mainVoltage <dbl>, backupVoltage <dbl>, temperature <dbl>, transformedX <lgl>, transformedY <lgl>

## For real applications we probably want to download many collars each day, week, month...
#  Call multiple collars

urls <- cdr_build_vec_urls(
  base_url = NULL,
  collar_id = ids,
  collar_key = keys,
  type = "gps",
  after_data_id = NULL,
  start_date = "2018-08-01T00:00:00"
)

gps_data <- cdr_call_vec_api(urls)

gps_data %>% dplyr::slice(1:2)
# A tibble: 2 x 46
  idPosition idCollar acquisitionTime scts  originCode   ecefX   ecefY  ecefZ latitude longitude height   dop idFixType positionError satCount ch01SatId ch01SatCnr
       <int>    <int> <chr>           <chr> <chr>        <int>   <int>  <int>    <dbl>     <dbl>  <int> <dbl>     <int> <lgl>            <int> <lgl>     <lgl>     
1   63091567    238   2018-09-27T01:~ 2018~ G          -1.86e6 -4.16e6 4.45e6     44.5     -114.   1935   5.6         5 NA                   0 NA        NA        
2   63089819    238   2018-09-27T01:~ 2018~ G          -1.86e6 -4.16e6 4.45e6     44.5     -114.   1910   6.2         5 NA                   0 NA        NA        
# ... with 29 more variables: ch02SatId <lgl>, ch02SatCnr <lgl>, ch03SatId <lgl>, ch03SatCnr <lgl>, ch04SatId <lgl>, ch04SatCnr <lgl>, ch05SatId <lgl>,
#   ch05SatCnr <lgl>, ch06SatId <lgl>, ch06SatCnr <lgl>, ch07SatId <lgl>, ch07SatCnr <lgl>, ch08SatId <lgl>, ch08SatCnr <lgl>, ch09SatId <lgl>, ch09SatCnr <lgl>,
#   ch10SatId <lgl>, ch10SatCnr <lgl>, ch11SatId <lgl>, ch11SatCnr <lgl>, ch12SatId <lgl>, ch12SatCnr <lgl>, idMortalityStatus <int>, activity <int>,
#   mainVoltage <dbl>, backupVoltage <dbl>, temperature <dbl>, transformedX <lgl>, transformedY <lgl>

```

## Future

- I imagine implementing custom and general database operations (because that is where our data should live, right?)
- Some code will be refactored to up consistency with other functions and packages in the collar family

