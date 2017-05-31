##' Perform sensititity analysis on model parameters.
##' 
##' @param mod the model object
##' @param n the number of replicates to simulate
##' @param pars character vector or comma-separated string of 
##' model parameters to simulate
##' 
##' @export
##' @rdname sens
sens_unif <- function(mod,n=100,pars=names(param(mod)),...) {
  pars <- mrgsolve:::cvec_cs(pars)
  pars <- as.numeric(param(mod))[pars]
  data <- sens_unif_idata(pars=pars,n=n,...)
  out <- mrgsim(mod,idata=data,carry.out=".n",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by=".n")
  out
}

##' @export
##' @rdname sens
sens_norm <- function(mod,n=100,pars=names(param(mod)),...) {
  pars <- mrgsolve:::cvec_cs(pars)
  pars <- as.numeric(param(mod))[pars]
  data <- sens_norm_idata(mod=mod,n=n,pars=pars,...)
  out <- mrgsim(mod,idata=data,carry.out=".n",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by=".n")
  out
}

##' @export
##' @rdname sens
sens_unif_idata <- function(pars,lower=0.2,upper=3,n=100,
                            spread=TRUE,...) {
  out <- mvuniform(n,pars,pars*lower,pars*upper)
  out <- cbind(data_frame(.n=1:n),out)
  if(!spread) out <- gather(out,par,value,2:ncol(out)) %>% mutate(.n=1:n())
  out
}

##' @export
##' @rdname sens
sens_norm_idata <- function(pars,cv,
                            n=100,
                            log = TRUE,
                            spread=TRUE,...) {
  cv <- diag(rep((cv/100)^2,length(pars)))
  out <- MASS::mvrnorm(n,log(pars),cv)
  out <- exp(out)
  out <- cbind(matrix(1:nrow(out),ncol=1, dimnames=list(NULL,".n")),out)
  out <- as.data.frame(out)
  if(!spread) out <- gather(out,par,value,2:ncol(out)) %>% mutate(.n=1:n())
  out
}



##' @export
##' @rdname sens
sens_unif_ <- function(x,.dots) {
  do.call(sens_unif,c(list(mod),.dots))
}
##' @export
##' @rdname sens
sens_norm_ <- function(mod,.dots) {
  do.call(sens_norm,c(list(mod),.dots))
}

mvuniform <- function(n,par,a,b,...) {
  parn <- names(par)
  out <- lapply(seq_along(par), function(i) {
    setNames(data_frame(runif(n,a[i],b[i])),parn[i])
  })
  out <- bind_cols(out)
  out
}


