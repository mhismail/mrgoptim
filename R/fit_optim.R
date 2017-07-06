

is_error <- function(x) {
  inherits(x,"try-error") 
}

check_ofv_formals <- function(ofv) {
  if(!identical(names(formals(ofv)),c("dv", "pred", "par"))) {
    stop("the formal arguments for ofv must be dv, pred, and par",call.=FALSE) 
  }
}


predict_optim <- function(pars,mod,data,dv = "DV", pred = "PRED",ofv,p,
                          dvindex,get_pred=FALSE,...) {
  p  <- optimhelp::graft(p,pars)
  p <- as.list(p)
  out <- dplyr::as_data_frame(mrgsim(mod,data=data,carry.out="evid",param=p))
  if(is_error(out)) {
    stop("failure in predict function",call.=FALSE) 
  }
  if(get_pred) return(as.data.frame(dplyr::as_data_frame(out)))
  ofv(data[dvindex,dv],unlist(out[dvindex,pred],use.names=FALSE),p)
}



##' Fit a model to data using optim.
##' 
##' @param mod a model object
##' @param data a simulation data set
##' @param dv name of column in \code{data} containing the dependent variable
##' @param pred name of the column in the simulated data containing prediction 
##' matching \code{dv}
##' @param evid name of column in \code{data} containing event ID information
##' @param ofv an \code{R} function that calculates the objective function
##' @param par a parset object
##' @param ... passed to \code{\link{optim}}
##' 
##' 
##' @export
##' @rdname fit_optim
fit_optim <- function(mod,data=NULL,dv="DV",pred="DV",evid="evid",ofv,par,...) {
  check_ofv_formals(ofv)
  if(!is.parset(par)) {
    stop("par argument must be a parset object",call.=FALSE) 
  }
  if(!is.mrgmod(mod)) {
    stop("mod argument must be a model object",call.=FALSE) 
  }
  if(is.null(data)) {
    data <- as.data.frame(unclass(mod@args$data))
    data[,"..zeros.."] <- NULL
    mod@args$data <- NULL 
  }
  if(!exists(dv,data)) {
    stop("couldn't find ",dv, " in data set",call.=FALSE) 
  }
  if(!exists(evid,data)) {
    stop("please identify evid column in data set", call.=FALSE) 
  }
  
  fit <- optim(par=initials(par),
               fn=predict_optim,
               mod=mod,
               data=data,
               dv=dv,
               pred=pred,
               ofv=ofv,
               p=par,
               dvindex = which(data[,evid]==0),
               ...)
  out <- predict_optim(fit$par,mod=mod,data=data,p=par,get_pred=TRUE)
  data[,"PRED"] <- out[,pred]
  return(c(fit,list(pars=graft(par,fit$par),tab=data)))
}


##' @export
##' @rdname fit_optim
fit_minqa <- function(mod,data=NULL,dv="DV",pred="DV",evid="evid",ofv,par,...) {
  stopifnot(requireNamespace("minqa"))
  check_ofv_formals(ofv)
  if(!is.parset(par)) {
    stop("par argument must be a parset object",call.=FALSE) 
  }
  if(!is.mrgmod(mod)) {
    stop("mod argument must be a model object",call.=FALSE) 
  }
  if(is.null(data)) {
    data <- as.data.frame(unclass(mod@args$data))
    data[,"..zeros.."] <- NULL
    mod@args$data <- NULL 
  }
  if(!exists(dv,data)) {
    stop("couldn't find ",dv, " in data set",call.=FALSE) 
  }
  if(!exists(evid,data)) {
    stop("please identify evid column in data set", call.=FALSE) 
  }
  
  fit <- minqa::newuoa(par=initials(par),
                       fn=predict_optim,
                       mod=mod,
                       data=data,
                       dv=dv,
                       pred=pred,
                       ofv=ofv,
                       p=par,
                       dvindex = which(data[,evid]==0),
                       ...)
  out <- predict_optim(fit$par,mod=mod,data=data,p=par,get_pred=TRUE)
  data[,"PRED"] <- out[,pred]
  return(c(fit,list(pars=graft(par,fit$par),tab=data)))
}
