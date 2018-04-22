# Negative log likelihood
ML_obj_fun <- function(raw,pred,var) {
  1 / 2 * sum(((raw - pred) * (raw - pred)) / var +
            log(var)) + 1 / 2 * length(raw) * log(2 * pi)
}


get_preds <- function (mod, params) {
  out <- mod %>%
    param(params) %>%
    zero.re() %>%
    carry.out(dv, cmt) %>%
    obsonly() %>%
    mrgsim(end = -1) %>%
    as.data.frame()

  return(out)
} 


ML_optim <- function(params, mod, output, var, input) {
  
  params <- 10 ^ params
  predicted <- get_preds(mod, params)
  
  predicted <- reformat(predicted, input, output)
  
  ML_obj_fun(predicted$dv, predicted[, 5], predicted[, 5 + length(output)])
}





# Covariance step functions -----------------------------------------------

# Step size for finite difference approximations
h <- function (atol, rtol, param) {
    (rtol) ^ (1 / 3) * max(param, atol)
}

hj <- Vectorize(h, c("param"))

get_matrices <- function(params, mod, output, var, input){
  mod_list <- as.list(mod)
  a <- unclass(simargs(mod)$data)
  a <- as.data.frame(a)
  a <- a[a$evid == 0, 2]
  
  dydtheta <- matrix(0, nrow = length(a), ncol = length(params))
  dgdtheta <- matrix(0, nrow = length(a), ncol = length(params))

  hja <- hj(unname(mod_list$solver["atol"]), unname(mod_list$solver["rtol"]), params)

  for (i in 1:length(params)) {
    new_params1 <- params
    new_params2 <- params
    

    new_params1[i] <- params[i] + hja[i]
    new_params2[i] <- params[i] - hja[i]

    a1 <- reformat(get_preds(mod, new_params1), input, output)
    a2 <- reformat(get_preds(mod, new_params2), input, output)

    dydthetai <- (a1[, 5] - a2[, 5]) / (2 * hja[i])
    dydtheta[, i] <- as.matrix(dydthetai)
    
    dgdthetai <- (a1[, 5 + length(output)] - a2[, 5 + length(output)]) / (2 * hja[i])
    dgdtheta[, i] <- as.matrix(dgdthetai)
  }
  list(dydtheta, dgdtheta)
}



reformat<-function(predicted, input, output) {
  for (i in 1:length(output)) {
    predicted[, 5] <- ifelse(input[i] == predicted$cmt, predicted[, i + 4], predicted[, 5])
    predicted[, 5 + length(output)] <- ifelse(input[i] == predicted$cmt,
                                          predicted[, i + 4 + length(output)],
                                          predicted[, 5 + length(output)])
    
  }
  return(predicted)
}


##' Fit a model to data using maximum likelihood objective function
##' with newuoa or optim
##' 
##' @param mod a model object
##' @param input a numeric vector containing observation compartments in data_set to be fit
##' @param output a character vector containing names of pred output columns
##' @param var a character vector containing names of variance output columns of preds
##' @param prms a character vector of parameters to fit
##' @param v_prms a character vector of variance parameters to fit
##' @param cov logical, perform covariance step
##' @param restarts number of times to restart fit with final estimates of previous optimization
##' @param method method to be used: "newuoa","Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN", "Brent"
##' @param options options passed to optim function, see ?optim for more information
##' @export
##' @rdname mrgoptim

mrgoptim <- function(mod,
                     input,
                     output,
                     var,
                     prms,
                     v_prms,
                     cov = TRUE,
                     restarts = 0,
                     method = "newuoa",
                     options = list(maxit = 10000)) {
  
  mod_list <- as.list(mod)
  
  data <- as.data.frame(unclass(simargs(mod)$data))
  
  if (!is.mrgmod(mod)) {
    stop("mod argument must be a model object", call. = FALSE) 
  }
  
  if (is.null(dim(data))) {
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
  
  if (!all(input %in% data$cmt)) {
    stop("couldn't find compartment/s ",
         paste(input[which(!input %in% data$cmt)], collapse=", "), 
         " in cmt column", call. = FALSE) 
  }
  
  if (!(length(input) == length(output) & length(input) == length(var))){
    stop("input, output, and var vectors should have same length", call. = FALSE)
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
  
  #Get all parameters in mod object
  params <- mod_list$param
  
  # Select only parameters to be estimated
  params <- params[which(names(params) %in% c(prms,v_prms))] %>%
    unlist() %>% log10()
  
  # Attach request to model object
  mod@args$Request <- c(output, var)
  
  
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
              output,
              var,
              input,
              control = options)} else {
                
        # Fit with newuoa
        minqa::newuoa(
              par = params,
              fn = ML_optim, 
              mod = mod,
              output = output,
              var = var,
              input = input)
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
              output,
              var,
              input,
              control = options)} else {
                
        minqa::newuoa(
          par = fit[[i - 1]]$par,
          fn = ML_optim, 
          mod = mod,
          output = output,
          var = var,
          input = input)
              }
      
      names(fit[[i]]$par) <- names(params)
    }
  }
  
  # Covariance step
  if (cov) { 
    
    params <- 10 ^ fit[[1 + restarts]]$par
    
    
    mats<- get_matrices(params, mod, output, var, input)
    
    M <- matrix (0, nrow = length(params), ncol = length(params))
    
    # n x p matrix
    dydtheta.all <- mats[[1]]
    
    # n x p matrix
    dgdtheta.all <- mats[[2]]
    
    # n-length vector
    variances <- reformat(get_preds(mod, params), input, output)[, 5 + length(output)]
    
    # which parameters are system parameters
    thetas <- which(names(params) %in% c(prms))
    
    # M is Fisher information matrix
    M <- 1 / 2 * (t(dgdtheta.all/(c(variances ^ 2))) %*% (dgdtheta.all))
    M[thetas, thetas] <- (M[thetas, thetas] + 
                            t(dydtheta.all[, thetas] / c(variances)) %*% (dydtheta.all[, thetas]))
    
    
    cov <- tryCatch(solve(M), error = function(err) "Error")
    
    
    if (is.matrix(cov)) {
      fit[[1 + restarts]]$cov <- cov
      fit[[1 + restarts]]$cor <- cov2cor(cov)
      fit[[1 + restarts]]$CVPercent <- sqrt(diag(cov)) / params * 100
    }else {
      fit[[1 + restarts]]$cov <- "Error in covariance step"
    }
  }
  
  fitted_data <- get_preds(mod, params)
  names(fitted_data)[c(5, 5 + length(output))] <- c("pred", "var")
  
  fit[[1 + restarts]]$fitted_data <- reformat(fitted_data, input, output)[, c(1:5, 5 + length(output))]
  fit[[1 + restarts]]$par<-10 ^ fit[[1 + restarts]]$par
  
  return(unclass(fit[[1 + restarts]]))
} 




