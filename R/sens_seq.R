##' Sensitivity analysis with parameter sequences
##' 
##' This is always a univariate (one parameter at a time) 
##' sensitivity analysis.
##' 
##' @param mod the model object
##' @param ... named sequences of parameters; also arguments
##' passed to mrgsim
##' 
##' @details
##' In contrast to other simulation functions, 
##' \code{\link{sens_seq}} always returns 
##' data in long format with respect to 
##' the parameters involved in sensitivity
##' analysis.
##' 
##' @examples
##' mod <- mrgsolve:::house() %>% ev(amt = 100)
##' 
##' out <- 
##'   mod %>%
##'   sens_seq(CL = seq(1,2,0.2), VC = c(10,20,30))
##'   
##' out
##' 
##' @seealso \code{\link{sens_grid}}
##' 
##' @export
sens_seq <- function(mod,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  out <- lapply(seq_along(args), function(i) {
    value <- unlist(args[i])
    idata <- tibble::data_frame(ID=seq_along(value),x=value)
    names(idata) <- c("ID", pars[i])
    mod <- strip_args(mod)
    out <- mrgsim(mod,idata=idata, ...)
    out <- mutate(out,name = pars[i])
    names(idata)[2] <- "value" 
    left_join(out,idata,by=c("ID"))
  })
  out <- bind_rows(out)
  out
}

##' @param .dots list of arguments to pass to \code{\link{sens_seq}}
##' @export
##' @rdname sens_seq
sens_seq_ <- function(mod,.dots) {
  do.call(sens_seq,c(list(mod),.dots))
}
