

##' Sensitivity analysis one-by-one
##' 
##' @param mod a model object
##' @param ... numeric vectors with names matching model parameter names
##' 
##' 
##' @examples
##' mod <- mrgsolve:::house() %>% ev(amt = 100)
##' 
##' mod %>%
##'   sens_each(CL = c(0.5, 1, 1.5), KA = c(0.8, 1.1, 2))
##' 
##' @export
sens_each <- function(mod, ...) {
  args <- list(...)
  ans <- imap(args, .f = function(value, name) {
    ret <- data_frame(a = seq_along(value), b = value)
    set_names(ret, c("ID", name))
  })
  sens_univariate(mod, ans, ...)
}
