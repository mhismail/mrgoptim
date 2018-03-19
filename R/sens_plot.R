
##' Plot sensitivity analysis results
##' 
##' @param data data frame of sensitivity analysis results
##' @param y name of the output variable to plot
##' @param x name of independent variable
##' @param col logical; if \code{TRUE} lines are colored by parameter value
##' @param log logical; if \code{TRUE}, y-axis is log-transformed
##' @param split logical; if \code{TRUE}, the data set is split on the
##' @param lwd passed to \code{geom_line} 
##' parameter name and a list of plots are returned; a single faceted plot is 
##' is returned otherwise
##' 
##' @export

sens_plot <- function(data, y, x = "time", col = split, 
                      log = FALSE, split = FALSE, lwd = 0.75) {
  
  assert_that(requireNamespace("ggplot2"))
  
  y <- enexpr(y)
  x <- enexpr(x)
  
  if(split){
    sp <- split(data, data$name)
  } else {
    sp <- split(data, rep(1,nrow(data)))  
  }
  
  out <- lapply(sp, function(.data) {
    
    nlev <- length(unique(.data$value))
    
    if(nlev <=1) col <- FALSE
    
    if(nlev <= 16 & col) {
      .data <- mutate(.data, sens_value = factor(signif(value,3)))
    } else {
      .data <- mutate(.data, sens_value = value)  
    }
    
    p <- ggplot2::ggplot(.data) 
    if(col) {
      p <- p + 
        ggplot2::geom_line(
          ggplot2::aes_string(x,y,group="ID",col="sens_value"),lwd = lwd
        )  
      if(nlev > 8 & nlev <= 16) {
        p <- p + ggplot2::guides(color=ggplot2::guide_legend(ncol=6))
      }
    } else {
      p <- p + 
        ggplot2::geom_line(
          ggplot2::aes_string(x,y,group="ID"), lwd = lwd
        )  
    }
    
    p <- p + ggplot2::facet_wrap(~name) + ggplot2::labs(color = "")
    
    p + ggplot2::theme_bw() + ggplot2::theme(legend.position = "top")
    
  })
  
  if(log) {
    out <- purrr::map(out, .f = function(x) {
      x + ggplot2::scale_y_continuous(trans = "log10", breaks = 10^seq(-50,50))  
    })
  }
  
  if(length(out)==1) return(out[[1]])
  
  return(out)
}

