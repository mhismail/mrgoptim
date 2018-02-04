##' Sensitivity analysis with all parameter combinations
##' 
##' @param mod the model object
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
sens_grid <- function(mod,...) {
  args <- list(...)
  pars <- intersect(names(args),names(param(mod)))
  args <- args[pars]
  idata <- do.call(expand.grid,args)
  idata <- mutate(idata,ID = seq_len(n()))
  mod <- strip_args(mod) %>% obsonly
  out <- mrgsim(mod,idata=idata,...)
  out <- left_join(as_data_frame(out), idata, by = "ID")
  mutate(out, name = "multivariate", value = 1)
}

