is_error <- function(x) {
  inherits(x,"try-error") 
}

predict_optim <- function(pars,mod,data,dv = "DV", pred = "PRED",.ofv,
                          dvindex,get_pred=FALSE,...) {
  pars <- lapply(pars,exp)
  mod <- param(mod,pars)
  out <- dplyr::as_data_frame(mrgsim(mod,data=data,carry.out="evid",param=pars))
  if(is_error(out)) {
    stop("failure in predict function",call.=FALSE) 
  }
  if(get_pred) return(as.data.frame(dplyr::as_data_frame(out)))
 .ofv(data[dvindex,dv],out[dvindex,pred],pars)
}

##' Fit a model to data using optim.
##' 
##' @export
##' @rdname fit_optim
fit_optim <- function(mod,data=NULL,dv="DV",pred="DV",.ofv,par,...) {
  if(is.null(data)) {
    data <- as.data.frame(unclass(mod@args$data))
    data[,"..zeros.."] <- NULL
    mod@args$data <- NULL 
  }
  fit <- optim(par=par,
               fn=predict_optim,
               mod=mod,
               data=data,
               dv=dv,
               pred=pred,
               .ofv=.ofv,
               dvindex = which(data$evid==0),
               ...)
  out <- predict_optim(fit$par,mod=mod,data=data,get_pred=TRUE)
  data[,"PRED"] <- out[,pred]
  return(list(fit=fit,tab=data,out=out))
}



