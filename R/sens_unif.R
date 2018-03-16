##' Sensitivity analysis with uniform distribtion
##' 
##' @param mod the model object
##' @param pars character vector or comma-separated string of 
##' @param .n the number of replicates to simulate
##' model parameters to simulate
##' @param univariate if \code{TRUE}, separate simulations are done for 
##' each input parameter
##' @param ... passed to \code{\link{sens_norm_idata}} and to mrgism
##' 
##' @details
##' See the \code{spread} argument to \code{\link{sens_unif_idata}}. 
##' 
##' @examples
##' 
##' library(dplyr)
##' 
##' mod <- mrgsolve:::house() %>% ev(amt = 100)
##' 
##' out <- mod %>% select(CL,VC) %>% sens_unif(.n=10)
##' 
##' @seealso \code{\link{sens_unif_idata}} \code{\link[dmutate]{covset}}
##' 
##' @export
sens_unif <- function(mod,pars=names(param(mod)),.n=100, 
                      univariate = FALSE, ...) {
  if(is.character(simargs(mod)$selected)) {
    pars <- simargs(mod)$selected  
  } else {
    pars <- cvec_cs(pars)
  }
  pars <- as.numeric(param(mod))[pars]
  data <- sens_unif_idata(pars=pars,.n=.n,...)
  
  if(univariate) {
    data <- col_sep(data, all = c("ID"))
    return(sens_univariate(mod, data, ...))
  }
  
  mod <- strip_args(mod) %>% obsonly
  out <- mrgsim(mod,
                idata=mutate(data,par=NULL),
                obsonly=TRUE,...)
  out <- left_join(as_data_frame(out),data,by="ID")
  mutate(out, name = "multivariate", value = 1)
}


##' @param .dots list of arguments to pass to \code{\link{sens_unif}}
##' @export
##' @rdname sens_unif
sens_unif_ <- function(mod,.dots) {
  do.call(sens_unif,c(list(mod),.dots))
}

##' Generate idata sets for sens_unif
##' 
##' @param pars named numeric vector of parameters
##' @param lower multiplier for lower bound
##' @param upper multiplier for upper bound
##' @param .n number of replicates to simulate
##' @param ... not used
##' 
##' @details
##' It is important to note that \code{lower} and \code{upper} do
##' not correspond to the \code{min} and \code{max} arguments
##' for \code{\link{runif}}. Rather, they modify the current value
##' of the parameter in a multiplicative way.  For example, to 
##' simulate from uniform distributions that range from 
##' half the parameter value to double the parameter value,
##' use \code{lower} equal to \code{0.5} and \code{upper}
##' equal to \code{2}.
##' 
##' @examples
##' pars <- c(CL = 1, VC = 2.2)
##' 
##' sens_unif_idata(pars, lower=0.67,upper=0.99, .n=5)
##' 
##' 
##' @seealso \code{\link{sens_unif}}
##' 
##' @export
sens_unif_idata <- function(pars,lower=1/upper,upper=3,.n=100,...) {
  out <- mvuniform(.n,pars,pars*lower,pars*upper)
  mutate(out, ID = seq(nrow(out)))
}

mvuniform <- function(.n,par,a,b,...) {
  parn <- names(par)
  out <- pmap(list(a,b,parn), function(.a, .b, .parn) {
    ans <- data_frame(runif(.n,.a,.b))
    setNames(ans,.parn)
  })
  out <- dplyr::bind_cols(out)
  out
}
