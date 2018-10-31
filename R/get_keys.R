#' Retrieve keys from a path to a key file or read all keys contained within a directory
#'
#' The key is need to call the Vectronics API and given the length of the key copy and paste errors seems likely.  The functions here help users access the keys in a programmatic fashion.
#'
#' @param key_path A length 1 character string describing the full path to a single key file.
#' @param key_dir A length 1 character string describing the full path to a directory containing, potentially many, key files
#'
#' @details cdr_get_keys is a wrapper for cdr_get_key where the former is retained to allow users to access a single file if desired.
#'
#' @return A character vector of keys
#' @export
#'
#' @examples
#' cdr_get_key(
#'   system.file(
#'     "extdata",
#'     "Collar123456_Registration.keyx",
#'     package = "CollarDownloadeR"
#'   )
#' )
#'
#' cdr_get_keys(
#'   system.file(
#'     "extdata",
#'     package = "CollarDownloadeR"
#'   )
#' )
cdr_get_key <- function(key_path) {
  is_file <- function(x) {
    !assertthat::is.dir(x)
  }

  assertthat::on_failure(is_file) <- function(call, env) {
    "key_path should be the path to a single file, not a directory.  Did you mean to call cdr_get_keys?"
  }

  assertthat::assert_that(is_file(key_path))
  assertthat::assert_that(is.character(key_path))
  assertthat::assert_that(file.exists(key_path))
  assertthat::assert_that(assertthat::has_extension(key_path, ext = "keyx"))
  assertthat::assert_that(assertthat::is.readable(key_path))

  xml2::read_xml(key_path) %>%
    xml2::xml_find_all("//key") %>%
    xml2::xml_text()
}

#' @rdname cdr_get_key
#' @export

cdr_get_keys <- function(key_dir) {
  assertthat::assert_that(assertthat::is.dir(key_dir))
  assertthat::assert_that(assertthat::is.readable(key_dir))

  key_paths <- cdr_key_paths(key_dir)

  purrr::map_chr(key_paths, cdr_get_key)
}