

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

##' @rdname select_mrgmod
##' @export
select_par <- function(.data, ...) {
  select.mrgmod(.data, ...)
}

##' @rdname select_mrgmod
##' @export
select_runs <- function(.data, ...) {
  menu <- c(names(param(.data)), names(init(.data)))
  values <- list(...)
  vars <- select_vars(menu, names(values))
  values <- values[vars]
  .data@args$selected_runs <- values
  .data
}


