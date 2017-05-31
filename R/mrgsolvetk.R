
##' @export
sens_unif_idata <- function(mod,pars,lower=0.2,upper=3,n=100,
                            spread=TRUE,...) {
  pars <- mrgsolve:::cvec_cs(pars)
  params <- as.numeric(param(mod))[pars]
  parmin <- params*lower
  parmax <- params*upper
  out <- mvuniform(n,pars,params*lower,params*upper)
  out <- cbind(data_frame(.n=1:n),out)
  if(!spread) out <- gather(out,par,value,2:ncol(out)) %>% mutate(.n=1:n())
  out
}

##' @export
sens_norm_idata <- function(mod,pars,cv,n=100,
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
  
  out <- MASS::mvrnorm(n,log(params),cv)
  out <- exp(out)
  out <- cbind(matrix(1:nrow(out),ncol=1, dimnames=list(NULL,".n")),out)
  out <- as.data.frame(out)
  if(!spread) out <- gather(out,par,value,2:ncol(out)) %>% mutate(.n=1:n())
  out
}


##' @export
sens_unif <- function(mod,n=100,...) {
  data <- sens_unif_idata(mod=mod,n=n,...)
  out <- mrgsim(mod,idata=data,carry.out=".n",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by=".n")
  out
}

##' Sensitivity analysis for log-normal parameters.
##' 
##' @param mod the model object
##' @export
sens_norm <- function(mod,n=100,...) {
  data <- sens_norm_idata(mod=mod,n=n,...)
  out <- mrgsim(mod,idata=data,carry.out=".n",obsonly=TRUE,...)
  out <- left_join(as.tbl(out),data,by=".n")
  out
}




mvuniform <- function(n,par,a,b,...) {
  out <- lapply(seq_along(par), function(i) {
    setNames(data_frame(runif(n,a[i],b[i])),par[i])
  })
  out <- bind_cols(out)
  out
}


