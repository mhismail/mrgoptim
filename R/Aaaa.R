##' @importFrom dplyr mutate bind_rows filter bind_cols
##' @importFrom dplyr left_join 
##' @importFrom tidyr gather spread
##' @importFrom MASS mvrnorm
##' @importFrom stats setNames
##' @importFrom tibble as_data_frame data_frame
##' @importFrom stats runif rnorm rlnorm optim
##' @importFrom mrgsolve mrgsim is.mrgmod
##' @importMethodsFrom mrgsolve as.data.frame param as.numeric
##' 
##' @importFrom optimhelp graft require_par is.parset
##' @importClassesFrom optimhelp parset 
##' @importMethodsFrom optimhelp initials as.list
NULL

globalVariables(c("time","ID","mod","par","value"))



##' mrgsolve simulation tool kit.
##' 
##' 
##' @rdname mrgsolvetk
##' @name mrgsolvetk
##' 
NULL