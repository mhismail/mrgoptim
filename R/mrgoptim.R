# Negative log likelihood
ML_obj_fun <- function(raw,pred,var) {
  1 / 2 * sum(((raw - pred) * (raw - pred)) / var +
            log(var)) + 1 / 2 * length(raw) * log(2 * pi)
}


get_preds <- function (mod, params) {
  out <- mod %>%
    param(params) %>%
    mrgsim(end = -1) %>%
    as.data.frame()

  return(out)
} 


ML_optim <- function(params, mod) {
  
  params <- 10 ^ params
  predicted <- get_preds(mod, params)
  
  ML_obj_fun(predicted$dv, predicted[, 5], predicted[, 6])
}





# Covariance step functions -----------------------------------------------

# Step size for finite difference approximations
h <- function (atol, rtol, param) {
    (rtol) ^ (1 / 3) * max(param, atol)
}


get_matrices <- function(params, mod){
  mod_list <- as.list(mod)
  a <- unclass(simargs(mod)$data)
  a <- as.data.frame(a)
  a <- a[a$evid == 0, 2]
  
  dydtheta <- matrix(0, nrow = length(a), ncol = length(params))
  dgdtheta <- matrix(0, nrow = length(a), ncol = length(params))

  hja <- vapply(params, 
                function(params) h(mod_list$atol, 
                                   mod_list$rtol, 
                                   params), 
                numeric(1))


  for (i in seq_along(params)) {
    new_params1 <- params
    new_params2 <- params
    

    new_params1[i] <- params[i] + hja[i]
    new_params2[i] <- params[i] - hja[i]

    a1 <- get_preds(mod, new_params1)
    a2 <- get_preds(mod, new_params2)

    dydthetai <- (a1[, 5] - a2[, 5]) / (2 * hja[i])
    dydtheta[, i] <- as.matrix(dydthetai)
    
    dgdthetai <- (a1[, 6] - a2[, 6]) / (2 * hja[i])
    dgdtheta[, i] <- as.matrix(dgdthetai)
  }
  list(dydtheta, dgdtheta)
}



##' Fit a model to data using maximum likelihood objective function
##' with newuoa or optim
##' 
##' @param mod a model object
##' @param output a character string containing name of prediction output column
##' @param var a character string containing name of variance output column of predictions
##' @param prms a character vector of parameters to fit
##' @param v_prms a character vector of variance parameters to fit
##' @param cov logical, perform covariance step
##' @param restarts number of times to restart fit with final estimates of previous optimization
##' @param method method to be used: "newuoa","Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN", "Brent"
##' @param options options passed to optim function, see ?optim for more information
##' @export
##' @rdname mrgoptim

mrgoptim <- function(mod,
                     output = "ipred",
                     var = "var",
                     prms,
                     v_prms,
                     cov = TRUE,
                     restarts = 0,
                     method =  c("newuoa", "Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN", "Brent"),
                     options = list(maxit = 10000)) {
  
  method <- match.arg(method)
  
  mod_list <- as.list(mod)
  
  if (!is.mrgmod(mod)) {
    stop("mod argument must be a model object", call. = FALSE) 
  }
  
  if (is.null(simargs(mod)$data)) {
    stop("dataset not found", call. = FALSE) 
  }
  
  if (!all(output %in% c(mod_list$cmt, mod_list$capture))) {
    stop("couldn't find ",
         paste(output[which(!output %in% c(mod_list$cmt, mod_list$capture))], collapse=", "), 
         " in model output", call. = FALSE) 
  }
  
  if (!all(var %in% c(mod_list$cmt, mod_list$capture))) {
    stop("couldn't find ",
         paste(output[which(!var %in% c(mod_list$cmt, mod_list$capture))], collapse=", "), 
         " in model output", call. = FALSE) 
  }
  
  if (!all(prms %in% names(mod_list$param))){
    stop("couldn't find ",
         paste(prms[which(!prms %in% names(mod_list$param))], collapse=", "),
         " in parameter list", call. = FALSE) 
  }
  
  if (!all(v_prms %in% names(mod_list$param))){
    stop("couldn't find ",
         paste(v_prms[which(!v_prms %in% names(mod_list$param))], collapse=", "),
         " in parameter list",call. = FALSE) 
  }
  
  # Attach request to model object
  mod@args$Request <- c(output, var)
  
  # Make sure random effects disabled
  mod <- zero.re(mod)
  mod <- carry.out(mod, dv, cmt)
  mod <- obsonly(mod)
  
  #Get all parameters in mod object
  params <- mod_list$param
  
  # Select only parameters to be estimated
  params <- params[which(names(params) %in% c(prms,v_prms))] %>%
    unlist() %>% log10()
  

  
  
  fit <-list()
  
  # Option to restart optimization with final estimates
  for (i in 1:(1 + restarts)) {
    
    # Initial optmization
    if (i == 1) {
      fit[[1]] <- if (method != "newuoa") {
        
        # Fit with optim
        optim(par = params,
              fn = ML_optim,
              gr = NULL,
              method = method,
              mod,
              control = options)} else {
                
        # Fit with newuoa
        minqa::newuoa(
              par = params,
              fn = ML_optim, 
              mod = mod)
              }
      
       # Optimization with newuoa strips names in output, add them back in
       names(fit[[1]]$par) <- names(params)
       
    # Optimization with final estimates of previous run   
    } else {
    
      fit[[i]] <- if (method != "newuoa") {
        optim(par = fit[[i - 1]]$par,
              fn = ML_optim,
              gr = NULL,
              method = method,
              mod,
              control = options)} else {
                
        minqa::newuoa(
          par = fit[[i - 1]]$par,
          fn = ML_optim, 
          mod = mod)
              }
      
      names(fit[[i]]$par) <- names(params)
    }
  }
  
  print(fit)
  
  # Covariance step
  if (cov) { 
    
    params <- 10 ^ fit[[1 + restarts]]$par
    
    
    mats <- get_matrices(params, mod)

    # n x p matrix
    dydtheta.all <- mats[[1]]
    
    # n x p matrix
    dgdtheta.all <- mats[[2]]
    
    # n-length vector
    variances <- get_preds(mod, params)[, 6]
    
    # which parameters are system parameters
    thetas <- which(names(params) %in% c(prms))
    
    # M is Fisher information matrix
    M <- 1 / 2 * crossprod(dgdtheta.all / variances ^ 2, dgdtheta.all)
    M[thetas, thetas] <- M[thetas, thetas] + 
                         crossprod(dydtheta.all[, thetas] / variances, dydtheta.all[, thetas])
    
    
    cov <- tryCatch(solve(M), error = function(err) return(err))
    fit[[1 + restarts]]$cov <- cov
    
    
    if (is.matrix(cov)) {
      fit[[1 + restarts]]$cor <- cov2cor(cov)
      fit[[1 + restarts]]$CVPercent <- sqrt(diag(cov)) / params * 100
    }
  }
  
  fitted_data <- get_preds(mod, params)
  names(fitted_data)[c(5, 6)] <- c("pred", "var")
  
  fit[[1 + restarts]]$fitted_data <- fitted_data
  fit[[1 + restarts]]$par <- 10 ^ fit[[1 + restarts]]$par
  
  return(unclass(fit[[1 + restarts]]))
} 




