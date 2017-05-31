

##' @importFrom dplyr mutate bind_rows bind_cols left_join
##' @importFrom tibble as_data_frame
##' 
NULL

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
  out <- left_join(as_data_frame(out),data,by=".n")
  out
}

##' @export
##' @rdname sens
sens_norm <- function(mod,n=100,pars=names(param(mod)),...) {
  pars <- mrgsolve:::cvec_cs(pars)
  pars <- as.numeric(param(mod))[pars]
  data <- sens_norm_idata(mod=mod,n=n,pars=pars,...)
  out <- mrgsim(mod,idata=data,carry.out=".n",obsonly=TRUE,...)
  out <- left_join(as_data_frame(out),data,by=".n")
  out
}


##' @export
##' @rdname sens
sens_seq <- function(mod,n=100,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  out <- lapply(seq_along(args), function(i) {
    value <- unlist(args[i])
    idata <- dplyr::data_frame(ID=seq_along(value),y=ID,x=value)
    names(idata) <- c("ID", ".n", pars[i])
    out <- dplyr::as_data_frame(mrgsim(mod,idata=idata,carry.out='.n',...))
    out <- mutate(out,param = pars[i])
    names(idata)[3] <- "value" 
    left_join(out,idata,by=c("ID", ".n"))
  })
  out <- bind_rows(out)
  out
}

##' @export
##' @rdname sens
sens_grid <- function(mod,n=100,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  idata <- do.call(expand.grid,args)
  idata <- mutate(idata,ID = seq_len(n()), .n=ID)
  out <- dplyr::as_data_frame(mrgsim(mod,idata=idata,carry.out=c('.n',pars),...))
  out
}



##' @export
##' @rdname sens
sens_covset <- function(mod,covset,n=100,...) {
  stopifnot(requireNamespace("dmutate"))
  stopifnot(inherits(covset,"covset"))
  idata <- dplyr::data_frame(ID = seq_len(n), .n=ID)
  idata <- dmutate::mutate_random(idata,covset)
  covs <- as.list(covset)
  vars <- unlist(lapply(covs,function(x) x$vars))
  out <- mrgsim(mod,idata=idata,obsonly=TRUE,carry.out=vars,...)
  dplyr::as_data_frame(out)
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
##' @export
##' @rdname sens
sens_seq_ <- function(mod,.dots) {
  do.call(sens_seq,c(list(mod),.dots))
}


##' @export
##' @rdname sens
sens_unif_idata <- function(pars,lower=0.2,upper=3,n=100,
                            spread=TRUE,...) {
  out <- mvuniform(n,pars,pars*lower,pars*upper)
  out <- cbind(dplyr::data_frame(.n=1:n),out)
  if(!spread) out <- tidyr::gather(out,par,value,2:ncol(out)) %>% mutate(.n=1:n())
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

mvuniform <- function(n,par,a,b,...) {
  parn <- names(par)
  out <- lapply(seq_along(par), function(i) {
    setNames(dplyr::data_frame(runif(n,a[i],b[i])),parn[i])
  })
  out <- dplyr::bind_cols(out)
  out
}


