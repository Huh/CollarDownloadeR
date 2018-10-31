#' A basic call to the Vectronics API
#'
#' @param url a character string representing the url to query
#'
#' @details At the time of this writing the API does not return any data.
#'
#' @return A tibble...eventually
#' @export
#'
#' @examples
#' #  Build url from base url, collar id, collar key and data type
#' url <- cdr_build_vec_urls(
#'   base_url = NULL,
#'   collar_id = cdr_get_id_from_key(
#'     system.file("extdata", package = "CollarDownloadeR")
#'   ),
#'   collar_key = cdr_get_keys(
#'     system.file(
#'       "extdata",
#'       package = "CollarDownloadeR"
#'     )
#'   ),
#'   type = "act"
#' )
#' # Call API - This will not work without a valid key and collar id
#' #cdr_call_vec_api(url)
cdr_call_vec_api <- function(url) {

  resp <- purrr::map(
    url,
    ~ httr::GET(.x)
  )

  parse <- purrr::map_df(
    resp,
    ~ jsonlite::fromJSON(
        httr::content(.x, "text"),
        simplifyVector = TRUE
      )
  ) %>%
  tibble::as.tibble(.)

}