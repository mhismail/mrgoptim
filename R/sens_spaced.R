##' Sensitivity analysis at evenly spaced values
##' 
##' This is always a univariate (one parameter at a time) 
##' sensitivity analysis. 
##' 
##' @param mod the model object
##' @param ... named numeric vectors of length 2, specifying the minimum
##' and maximum value for that parameter
##' @param .n number of evenly spaced parameter values to simulate
##'
##' @examples
##' mod <- mrgsolve:::house() %>% ev(amt = 100)
##' 
##' mod %>%
##'   sens_spaced(CL = c(0.5,1.5), VC = c(20,30), .n = 5)
##'
##' @export 
sens_spaced <- function(mod, ...,  .n = 5, .factor = NULL) {
  if(is.numeric(.factor)) {
    return(sens_spaced_factor(mod = mod, ..., .n = .n, .factor = .factor))  
  }
  x <- list(...)  
  data <- imap(x, .f = function(.x,.y) {
    stopifnot(length(.x)==2)
    ans <- data_frame(ID = 1, value = seq(.x[1], .x[2], length.out = .n))
    set_names(ans, c("ID", .y))
  })
  sens_univariate(mod, data, ...)
}

##' @rdname 
##' @export
sens_spaced_factor <- function(mod, ..., pars = names(param(mod)),
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
  do.call(sens_spaced, pars)
}


