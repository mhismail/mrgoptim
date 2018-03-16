##' Sensitivity analysis at evenly spaced values
##' 
##' This is always a univariate (one parameter at a time) 
##' sensitivity analysis. 
##' 
##' @param mod the model object
##' @param ... named numeric vectors of length 2, specifying the minimum
##' and maximum value for that parameter
##' @param .n number of evenly spaced parameter values to simulate
##' @param .factor used to create a range for sensitivity analysis
##' based on the value of the selected parameters; the upper end 
##' of the range is \code{.factor} times the parameter value and the 
##' lower end of the range is the parameter value divided 
##' by \code{.factor}
##' @param pars a character vector of parameter names on which 
##' to do sensitivity analysis
##'
##' @examples
##' mod <- mrgsolve:::house() %>% ev(amt = 100)
##' 
##' mod %>%
##'   sens_range(CL = c(0.5,1.5), VC = c(20,30), .n = 5)
##'
##' @export 
sens_range <- function(mod, ...,  .n = 5, .factor = NULL) {
  assert_that(.n > 0)
  if(is.numeric(.factor)) {
    return(sens_range_factor(mod = mod, ..., .n = .n, .factor = .factor))  
  }
  x <- list(...)  
  data <- imap(x, .f = function(.x,.y) {
    stopifnot(length(.x)==2)
    ans <- data_frame(ID = 1, value = seq(.x[1], .x[2], length.out = .n))
    set_names(ans, c("ID", .y))
  })
  sens_univariate(mod, data, ...)
}

##' @rdname sens_range
##' @export
sens_range_factor <- function(mod, ..., pars = names(param(mod)),
                               .n = 5, .factor = 2) {
  if(length(.factor)==1) {
    .factor <- c(1/.factor, .factor)  
  }
  assert_that(length(.factor)==2)
  assert_that(.factor[2] > .factor[1], msg = ".factor must be c(lower, upper)")
  if(is.character(simargs(mod)$selected)) {
    pars <- simargs(mod)$selected  
  } else {
    pars <- cvec_cs(pars)
  }
  pars <- as.list(param(mod))[pars]
  pars <- map(pars, function(.p) {
    .p*.factor    
  })
  pars$mod <- mod
  pars$.n <- .n
  pars$.factor <- NULL
  do.call(sens_range, pars)
}


