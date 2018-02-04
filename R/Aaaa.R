##' @import methods
##' @importFrom dplyr mutate bind_rows filter bind_cols
##' @importFrom dplyr left_join select
##' @importFrom tidyr gather spread
##' @importFrom stats setNames
##' @importFrom tibble as_data_frame data_frame
##' @importFrom stats runif rnorm rlnorm optim
##' @importFrom mrgsolve mrgsim is.mrgmod ev as.ev
##' @importFrom purrr imap pmap map map_df map_chr
##' @importFrom assertthat assert_that
##' @importFrom rlang set_names
##' @importFrom magrittr %>%
##' @importMethodsFrom mrgsolve as.data.frame param as.numeric
##' 
##' @importFrom optimhelp graft require_par is.parset
##' @importClassesFrom optimhelp parset 
##' @importMethodsFrom optimhelp initials as.list
##' 
NULL

globalVariables(c("time","ID","mod","par","value","evid","name"))



##' mrgsolve simulation tool kit
##' 
##' 
##' @section Sensitivity Analysis:
##' 
##' \code{\link{sens_unif}} Simulate from uniform parameter distributions located
##' around nominal parameter values
##' 
##' \code{\link{sens_norm}} Simulate from log-normal parameter distributions
##' located around nominal parameter values
##' 
##' \code{\link{sens_seq}} Simulate from each value entered for each 
##' parameter
##' 
##' \code{\link{sens_grid}} Simulate from all combinations of parameter values
##' 
##' \code{\link{sens_spaced}} Simulate from evenly-spaced values between 
##' a set of lower and upper parameter bounds
##' 
##' \code{\link{sens_covset}} Simulate from a covset object using the 
##' \code{dmutate} package
##' 
##' 
##' @rdname mrgsolvetk
##' @name mrgsolvetk
##' 
NULL