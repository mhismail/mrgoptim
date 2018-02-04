re_id <- function(x) {
  l <- sapply(x, nrow)
  end <- cumsum(l)
  start <- c(0, end[-length(l)]) + 1
  pmap(list(x,start,end), .f = function(data,start,end) {
    mutate(data, ID = seq(start,end))
  })
}

sens_univariate <- function(mod, data, ...) {
  data <- re_id(data)
  mod <- strip_args(mod) %>% obsonly
  map_df(data, .f = function(idata) {
    out <- mrgsim(mod, idata = idata, ...) %>% as_data_frame
    take <- setdiff(names(idata), "ID")
    left_join(out, gather(idata, name, value, take), by = "ID")
  }) 
}

