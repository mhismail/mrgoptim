
##' Sensitivity analysis with uniform distribtion.
##' 
##' @param mod the model object
##' @param n the number of replicates to simulate
##' @param pars character vector or comma-separated string of 
##' model parameters to simulate
##' @param ... passed to \code{\link{sens_norm_idata}} and to mrgism
##' 
##' @details
##' See the \code{spread} argument to \code{\link{sens_unif_idata}}. 
##' 
##' @examples
##' mod <- mrgsolve:::house()
##' 
##' out <- sens_unif(mod, n=10, pars="CL,VC")
##' 
##' @seealso \code{\link{sens_unif_idata}} \code{\link[dmutate]{covset}}
##' 
##' @export
sens_unif <- function(mod,n=100,pars=names(param(mod)),...) {
  pars <- cvec_cs(pars)
  pars <- as.numeric(param(mod))[pars]
  data <- sens_unif_idata(pars=pars,n=n,...)
  mod <- strip_args(mod)
  out <- mrgsim(mod,
                idata=mutate(data,par=NULL),
                carry.out=".n",obsonly=TRUE,...)
  out <- dplyr::left_join(tibble::as_data_frame(out),data,by=".n")
  out
}

##' @param .dots list of arguments to pass to \code{\link{sens_unif}}
##' @export
##' @rdname sens_unif
sens_unif_ <- function(mod,.dots) {
  do.call(sens_unif,c(list(mod),.dots))
}


##' Sensitivity analysis with log-normal distributions.
##' 
##' @param mod the model object
##' @param n the number of replicates to simulate
##' @param pars character vector or comma-separated string of model
##' parameters to simulate
##' @param ... passed to \code{\link{sens_norm_idata}} and to mrgism
##' 
##' @details
##' See the \code{spread} argument to \code{\link{sens_norm_idata}}. 
##' 
##' @seealso \code{\link{sens_norm_idata}} \code{\link{sens_covset}}
##' 
##' @export
sens_norm <- function(mod,n=100,pars=names(param(mod)),...) {
  pars <- cvec_cs(pars)
  pars <- as.numeric(param(mod))[pars]
  data <- sens_norm_idata(n=n,pars=pars,...)
  mod <- strip_args(mod)
  out <- mrgsim(mod,
                idata=mutate(data,par=NULL),
                carry.out=".n",obsonly=TRUE,...)
  out <- dplyr::left_join(tibble::as_data_frame(out),data,by=".n")
  out
}

##' @param .dots list of arguments to pass to \code{\link{sens_norm}}
##' @export
##' @rdname sens_norm
sens_norm_ <- function(mod,.dots) {
  do.call(sens_norm,c(list(mod),.dots))
}

##' Sensitivity analysis with parameter sequences.
##' 
##' @param mod the model object
##' @param n the number of replicates to simulate
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
##' mod <- mrgsolve:::house()
##' out <- 
##'   mod %>%
##'   ev(amt=100) %>%
##'   Req(CP) %>%
##'   sens_seq(CL = seq(1,2,0.2), VC = seq(10,40,5))
##'   
##' out
##' 
##' @seealso \code{\link{sens_grid}}
##' 
##' @export
sens_seq <- function(mod,n=100,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  out <- lapply(seq_along(args), function(i) {
    value <- unlist(args[i])
    idata <- tibble::data_frame(ID=seq_along(value),y=ID,x=value)
    names(idata) <- c("ID", ".n", pars[i])
    mod <- strip_args(mod)
    out <- mrgsim(mod,idata=idata,carry.out='.n',...)
    out <- mutate(out,param = pars[i])
    names(idata)[3] <- "value" 
    left_join(out,idata,by=c("ID", ".n"))
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

##' Sensitivity analysis with all parameter combinations.
##' 
##' @param mod the model object
##' @param n the number of replicates to simulate
##' @param ... named sequences of parameters; also arguments
##' passed to mrgsim
##' 
##' @details 
##' In contrast to other sensitivity analysis functions, 
##' \code{\link{sens_grid}} always returns data in 
##' wide format with respect to parameters involved
##' in the sensitivity analysis.
##' 
##' @examples
##' mod <- mrgsolve:::house()
##' out <- 
##'   mod %>%
##'   ev(amt=100) %>%
##'   Req(CP) %>%
##'   sens_grid(CL = seq(1,2,0.2), VC = seq(10,40,5))
##'   
##' out
##' 
##' 
##' @seealso \code{\link{sens_seq}}
##' 
##' @export
sens_grid <- function(mod,n=100,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  idata <- do.call(expand.grid,args)
  idata <- mutate(idata,ID = seq_len(n()), .n=ID)
  mod <- strip_args(mod)
  out <- mrgsim(mod,idata=idata,carry.out=c('.n',pars),...)
  as_data_frame(out)
}



##' Sensitivity analysis using covset objects.
##' 
##' @param mod the model object
##' @param covset a covset object
##' @param n the number of replicates to simulate
##' @param ... passed to mutate_random and mrgsim
##' 
##' @seealso \code{\link{sens_unif}} \code{\link{sens_norm}} 
##' 
##' @export
sens_covset <- function(mod,covset,n=100,...) {
  stopifnot(requireNamespace("dmutate"))
  stopifnot(inherits(covset,"covset"))
  mod <- strip_args(mod)
  idata <- data_frame(ID = seq_len(n), .n=ID)
  idata <- dmutate::mutate_random(idata,covset,...)
  covs <- as.list(covset)
  vars <- unlist(lapply(covs,function(x) x$vars))
  out <- mrgsim(mod,idata=idata,obsonly=TRUE,carry.out=vars,...)
  as_data_frame(out)
}


##' Generate idata sets for sens_unif.
##' 
##' @param pars named numeric vector of parameters
##' @param lower multiplier for lower bound
##' @param upper multiplier for upper bound
##' @param n number of replicates to simulate
##' @param spread if \code{TRUE} the data frame is returned in wide format
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
##' sens_unif_idata(pars, lower=0.67,upper=0.99, n=5)
##' 
##' sens_unif_idata(pars, lower=0.67,upper=0.99, n=5, spread=FALSE)
##' 
##' @seealso \code{\link{sens_unif}}
##' 
##' @export
sens_unif_idata <- function(pars,lower=0.2,upper=3,n=100,spread=TRUE,...) {
  out <- mvuniform(n,pars,pars*lower,pars*upper)
  out <- cbind(data_frame(.n=1:n),out)
  if(!spread) {
    out <- gather(out,par,value,2:ncol(out)) 
    out <- mutate(out,.n=1:n())
  }
  out
}

##' Generate idata set for sens_norm. 
##' 
##' @param pars named numeric vector of parameters
##' @param cv coefficient of variation 
##' @param n number of replicates to simulate
##' @param spread if \code{TRUE} the data frame is returned in wide format
##' @param ... not used
##' 
##' @seealso \code{\link{sens_norm}}
##' 
##' @export
sens_norm_idata <- function(pars,cv,n=100,
                            spread=TRUE,...) {
  np <- length(pars)
  cv <- diag(rep((cv/100)^2,np),nrow=np,ncol=np)
  out <- MASS::mvrnorm(n,log(pars),cv)
  if(length(pars)==1) {
    out <- matrix(out,ncol=1,dimnames=list(NULL,names(pars))) 
  }
  out <- exp(out)
  out <- cbind(matrix(1:nrow(out),ncol=1, dimnames=list(NULL,".n")),out)
  out <- as.data.frame(out)
  if(!spread) {
    out <- gather(out,par,value,2:ncol(out)) 
    out <- mutate(out,.n=1:n())
  }
  out
}

mvuniform <- function(n,par,a,b,...) {
  parn <- names(par)
  out <- lapply(seq_along(par), function(i) {
    setNames(tibble::data_frame(runif(n,a[i],b[i])),parn[i])
  })
  out <- dplyr::bind_cols(out)
  out
}

strip_args <- function(x) {
  x@args$data <- NULL
  x@args$idata <- NULL
  x
}

