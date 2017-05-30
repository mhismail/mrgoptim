
##' @export
sens_uniform <- function(mod,pars,lower=0.2,upper=3,niter=100,
                         spread=TRUE,...) {
  pars <- mrgsolve:::cvec_cs(pars)
  params <- as.numeric(param(mod))[pars]
  parmin <- params*lower
  parmax <- params*upper
  
  out <- lapply(seq_along(params), function(i) {
    x <- runif(niter,parmin[i],parmax[i])
    data_frame(iter=1:niter,par=wparams[i],value=x)
  }) %>% bind_rows
  
  if(spread) {
    out <- spread(out,par,value)
  } else {
    out <- mutate(out,iter=1:n()) 
  }
  out
}

##' @export
sens_lognorm <- function(mod,pars,cv,niter=100,
                         log = TRUE,
                         spread=TRUE,...) {
  pars <- mrgsolve:::cvec_cs(pars)
  params <- as.numeric(param(mod))[pars]
  cv <- as.matrix(cv/100)
  if(nrow(cv) != length(params)) {
    if(length(cv)==1) cv <- diag(rep(cv,length(params)))
  } else {
    stop("Wrong length for cv") 
  }
  
  out <- MASS::mvrnorm(niter,log(params),cv)
  out <- exp(out)
  out <- cbind(matrix(1:nrow(out),ncol=1, dimnames=list(NULL,"iter")),out)
  out <- as.data.frame(out)
  if(!spread) out <- gather(out,par,value,2:ncol(out)) %>% mutate(iter=1:n())
  out
}


##' @export
sim_uniform <- function(mod,niter=100,...) {
  data <- sens_uniform(mod=mod,niter=niter,...)
  out <- mrgsim(mod,idata=data,carry.out="iter",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by="iter")
  out
}

##' Sensitivity analysis for log-normal parameters.
##' 
##' @param mod the model object
##' @export
sim_lognorm <- function(mod,niter=100,...) {
  data <- sens_lognorm(mod=mod,niter=niter,...)
  out <- mrgsim(mod,idata=data,carry.out="iter",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by="iter")
  out
}









