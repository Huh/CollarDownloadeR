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

## Vectronics
Thankfully Vectronics is quite forward thinking when it comes to data access.  They have developed an API or Application Programming Interface, which means that we can write code that retrieves data from their servers, cool!  To use the API we need to build a url like www.google.com, but in this case several species numbers are included to tell the server which data we desire.  The primary components of the url that we need to build are the base address, collar id, collar key and data type.  Once we have assembled these components we can call the api and have it return our data.

Two optional parameters, which are as of yet untested, allow the user to only download data after some data id or date.  This should be helpful for those doing weekly downloads as it will not require the user to download every fix each time they retrieve data.

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

```

## Future

- I imagine implementing custom and general CRUD like operations for databases (because that is where our data should live, right?)
- Some code will be refactored to up consistency with other functions and packages in the collar family

