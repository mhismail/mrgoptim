mrgsolvetk
==========

A toolkit to be used with `mrgsolve`

Examples
========

``` r
library(dplyr)
library(mrgsolve)
library(mrgsolvetk)

mod <- mread_cache("pk1cmt",modlib())
mod <- ev(mod, amt=100) %>% Req(CP)

param(mod)
```

    . 
    .  Model parameters (N=6):
    .  name value . name value
    .  CL   1     | KM   2    
    .  KA1  1     | VC   20   
    .  KA2  1     | VMAX 0

Sensitivity analyses
--------------------

### `sens_unif`

-   Draw parameters from uniform distribution based on current parameter values
-   `lower` and `upper` scale the parameter value to provide `a` and `b` arguments to `runif`

``` r
mod %>% sens_unif(n=10, pars="CL,VC,KA1", lower=0.2, upper=3)
```

    . # A tibble: 250 × 7
    .       ID  time    .n       CP       CL       VC       KA1
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>     <dbl>
    . 1      1     0     1 0.000000 2.218059 13.99449 0.7919642
    . 2      1     1     1 3.577635 2.218059 13.99449 0.7919642
    . 3      1     2     1 4.673756 2.218059 13.99449 0.7919642
    . 4      1     3     1 4.722725 2.218059 13.99449 0.7919642
    . 5      1     4     1 4.362976 2.218059 13.99449 0.7919642
    . 6      1     5     1 3.874079 2.218059 13.99449 0.7919642
    . 7      1     6     1 3.374457 2.218059 13.99449 0.7919642
    . 8      1     7     1 2.910751 2.218059 13.99449 0.7919642
    . 9      1     8     1 2.498109 2.218059 13.99449 0.7919642
    . 10     1     9     1 2.138293 2.218059 13.99449 0.7919642
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.492332 28.67462
    . 2      1     1     1 2.138923 1.492332 28.67462
    . 3      1     2     1 2.817318 1.492332 28.67462
    . 4      1     3     1 2.963916 1.492332 28.67462
    . 5      1     4     1 2.920099 1.492332 28.67462
    . 6      1     5     1 2.811189 1.492332 28.67462
    . 7      1     6     1 2.683038 1.492332 28.67462
    . 8      1     7     1 2.552276 1.492332 28.67462
    . 9      1     8     1 2.424794 1.492332 28.67462
    . 10     1     9     1 2.302544 1.492332 28.67462
    . # ... with 240 more rows

### `sens_seq`

-   Give a sequence for one or more parameters

``` r
mod %>% sens_seq(CL = seq(2,12,2), VC = seq(30,100,10))
```

    . # A tibble: 364 × 6
    .       ID  time    .n       CP param value
    .    <dbl> <dbl> <dbl>    <dbl> <chr> <dbl>
    . 1      1     0     1 0.000000    CL     2
    . 2      1     0     1 0.000000    CL     2
    . 3      1     1     1 2.983100    CL     2
    . 4      1     2     1 3.796642    CL     2
    . 5      1     3     1 3.839062    CL     2
    . 6      1     4     1 3.622247    CL     2
    . 7      1     5     1 3.332182    CL     2
    . 8      1     6     1 3.035183    CL     2
    . 9      1     7     1 2.753741    CL     2
    . 10     1     8     1 2.494408    CL     2
    . # ... with 354 more rows

### `sens_grid`

-   Like `sens_seq` but performs all combinations

``` r
mod %>%  sens_grid(CL = seq(1,10,1), VC = seq(20,40,5))
```

    . # A tibble: 1,300 × 6
    .       ID  time    .n    CL    VC       CP
    .    <dbl> <dbl> <dbl> <dbl> <dbl>    <dbl>
    . 1      1     0     1     1    20 0.000000
    . 2      1     0     1     1    20 0.000000
    . 3      1     1     1     1    20 3.070263
    . 4      1     2     1     1    20 4.050011
    . 5      1     3     1     1    20 4.268005
    . 6      1     4     1     1    20 4.212711
    . 7      1     5     1     1    20 4.063489
    . 8      1     6     1     1    20 3.885997
    . 9      1     7     1     1    20 3.704085
    . 10     1     8     1     1    20 3.526235
    . # ... with 1,290 more rows

### `sens_covset`

-   Use `dmutate` to generate random variates for each parameter

``` r
cov1 <- dmutate::covset(CL ~ runif(1,3.5), VC[0,] ~ rnorm(50,25))

cov1
```

    .  Formulae                 
    .    CL ~ runif(1, 3.5)     
    .    VC[0, ] ~ rnorm(50, 25)

``` r
out <- mod %>% sens_covset(cov1) 
```

``` r
out
```

    . # A tibble: 2,500 × 5
    .       ID  time       CL       VC       CP
    .    <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0 3.237641 43.12225 0.000000
    . 2      1     1 3.237641 43.12225 1.403522
    . 3      1     2 3.237641 43.12225 1.818331
    . 4      1     3 3.237641 43.12225 1.876755
    . 5      1     4 3.237641 43.12225 1.810884
    . 6      1     5 3.237641 43.12225 1.705607
    . 7      1     6 3.237641 43.12225 1.591695
    . 8      1     7 3.237641 43.12225 1.480045
    . 9      1     8 3.237641 43.12225 1.374271
    . 10     1     9 3.237641 43.12225 1.275339
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL        VC
    .    <dbl>    <dbl>     <dbl>
    . 1      1 3.237641 43.122252
    . 2      2 2.791114 42.941073
    . 3      3 2.175689  1.924614
    . 4      4 1.758533 48.197701
    . 5      5 1.863387 73.410148
    . 6      6 1.574731 50.023650
    . 7      7 2.253445 78.016324
    . 8      8 1.529750 70.918682
    . 9      9 1.494275 63.025979
    . 10    10 2.051338 81.112392
    . # ... with 90 more rows

Estimation `stats::optim`
=========================

Load a data set
---------------

``` r
data(exTheoph)
df <- as.data.frame(exTheoph)
id1 <- filter(df, ID==3) %>% mutate(DV = conc)
```

Load a model
------------

``` r
mod <- mread("pk1cmt", modlib())
```

Define an objective function
----------------------------

``` r
ofv <- function(dv,pred,par) {
  a <- sum((dv-pred)^2) 
  return(a)
}
```

Define parameters to estimate
-----------------------------

``` r
library(optimhelp)
par <- parset(log_par("CL", 0.1),
              log_par("VC", 1.1),
              log_par("KA1",1.1))
```

Fit
---

``` r
fit <- 
  mod %>% 
  data_set(id1) %>%
  fit_optim(pred="CP",.ofv=ofv,par=par)
```

``` r
fit$pars
```

    .  name     value transf tr fx
    .    CL 0.0395555    log  u   
    .    VC 0.4858391    log  u   
    .   KA1 2.4537226    log  u

Plot
----

``` r
library(ggplot2)
ggplot(data=fit$tab) + 
  geom_point(aes(time,conc)) +
  geom_line(aes(time,PRED)) 
```

![](inst/maintenance/img/README-unnamed-chunk-16-1.png)

With fixed parameter
--------------------

``` r
library(optimhelp)
par <- parset(log_par("CL", 0.1),
              log_par("VC", 1.1),
              log_par("KA1",1.8,fixed=TRUE))
```

Fit
---

``` r
fitt <- 
  mod %>% 
  data_set(id1) %>%
  fit_optim(pred="CP",.ofv=ofv,par=par)
```

``` r
fitt$pars
```

    .  name     value transf tr fx
    .    CL 0.0424438    log  u   
    .    VC 0.4482733    log  u   
    .   KA1 1.8000000    log  u  *

``` r
fit$value
```

    . [1] 0.4362742

``` r
fitt$value
```

    . [1] 1.619208
