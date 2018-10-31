#' Create full paths to key files given a path to the directory containing the key files
#'
#' @param key_dir A length 1 character string describing the path to the directory (on your machine) that houses key files
#' @param ext A length 1 character string that is interpretable as a regular expression. Defaults to keyx, which should be correct for key files, but could be used to list files of any type by modifying ext argument.
#'
#' @return A character vector with a path for each file in key_dir
#' @export
#'
#' @examples
#' cdr_key_paths(
#'   system.file("extdata", package = "CollarDownloadeR")
#' )
cdr_key_paths <- function(key_dir, ext = "keyx") {
  assertthat::assert_that(assertthat::is.string(key_dir))
  assertthat::assert_that(assertthat::is.dir(key_dir))
  assertthat::assert_that(assertthat::is.readable(key_dir))

  list.files(key_dir, pattern = ext, full.names = TRUE)
}