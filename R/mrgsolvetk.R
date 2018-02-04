

##' A select method for mrgmod objects
##' 
##' @param .data the model object
##' @param ... unquoted parameter names
##' 
##' @return The model object.
##' 
##' @rdname select_mrgmod
##' 
##' @export
select.mrgmod <- function(.data, ...) {
  menu <- c(names(param(.data)), names(init(.data)))
  vars <- select_vars(menu, !!!quos(...))
  .data@args$selected <- vars
  .data
}

