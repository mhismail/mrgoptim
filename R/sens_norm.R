##' Sensitivity analysis with log-normal distributions
##' 
##' @param mod the model object
##' @param .n the number of replicates to simulate
##' @param pars character vector or comma-separated string of model
##' parameters to simulate
##' @param univariate if \code{TRUE}, separate simulations are done for 
##' each input parameter
##' @param ... passed to \code{\link{sens_norm_idata}} and to mrgism
##' 
##' @seealso \code{\link{sens_norm_idata}} \code{\link{sens_covset}}
##' 
##' @export
sens_norm <- function(mod, pars=names(param(mod)), .n = 100, 
                      univariate = FALSE, ...) {
  if(is.character(simargs(mod)$selected)) {
    pars <- simargs(mod)$selected  
  } else {
    pars <- cvec_cs(pars)
  }
  pars <- as.numeric(param(mod))[pars]
  data <- sens_norm_idata(.n=.n,pars=pars,...)
  
  if(univariate) {
    data <- col_sep(data, all = c("ID"))
    return(sens_univariate(mod, data, ...))
  }
  
  mod <- strip_args(mod) %>% obsonly
  out <- mrgsim(mod,
                idata = mutate(data, par=NULL),
                obsonly=TRUE, ...)
  out <- left_join(as_data_frame(out),data,by="ID")
  mutate(out, name = "multivariate", value = 1)
}

##' @param .dots list of arguments to pass to \code{\link{sens_norm}}
##' @export
##' @rdname sens_norm
sens_norm_ <- function(mod,.dots) {
  do.call(sens_norm,c(list(mod),.dots))
}


##' Generate idata set for sens_norm
##' 
##' @param pars named numeric vector of parameters
##' @param cv coefficient of variation 
##' @param .n number of replicates to simulate
##' @param ... not used
##' 
##' @seealso \code{\link{sens_norm}}
##' 
##' @export
sens_norm_idata <- function(pars,cv,.n=100,...) {
  assert_that(requireNamespace("MASS"))
  np <- length(pars)
  cv <- diag(rep((cv/100)^2,np),nrow=np,ncol=np)
  out <- MASS::mvrnorm(.n,log(pars),cv)
  if(length(pars)==1) {
    out <- matrix(out,ncol=1,dimnames=list(NULL,names(pars))) 
  }
  out <- exp(out)
  out <- as.data.frame(out)
  mutate(out, ID = seq(nrow(out)))
}