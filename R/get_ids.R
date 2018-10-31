#' Extract the collar ID from either key filenames or the actual key XML
#'
#' @param key_dir A length 1 character string describing the path to the directory (on your machine) that houses key files
#' @param ... Other arguments to pass to cdr_key_paths
#'
#' @details Vectronics includes the collar ID in the key file name as well as within the XML of the .keyx file.  These functions give the user the option of either extracting the information from the name of the file(s) cdr_get_id_from_fnames or reading the ID encoded in the key file cdr_get_id__from_key.
#'
#' @return character vector of collar IDs
#' @export
#'
#' @examples
#' cdr_get_id_from_fnames(
#'   system.file("extdata", package = "CollarDownloadeR")
#' )
#' cdr_get_id_from_key(
#'   system.file("extdata", package = "CollarDownloadeR")
#' )
cdr_get_id_from_fnames <- function(key_dir, ...) {
  assertthat::assert_that(assertthat::is.dir(key_dir))
  assertthat::assert_that(assertthat::is.readable(key_dir))

  paths <- cdr_key_paths(key_dir, ...)

  assertthat::assert_that(
    all(
      file.exists(cdr_key_paths(key_dir))
    )
  )

  gsub("(.*Collar)([0-9]+)(_.*)", "\\2", paths)
}

#' @rdname cdr_get_id_from_fnames
#' @export

cdr_get_id_from_key <- function(key_dir) {
  assertthat::assert_that(assertthat::is.dir(key_dir))
  assertthat::assert_that(assertthat::is.readable(key_dir))

  key_paths <- cdr_key_paths(key_dir)

  purrr::map_chr(key_paths,
    ~ xml2::read_xml(.x) %>%
    xml2::xml_find_all("//collar") %>%
    xml2::xml_attr("ID")
  )
}