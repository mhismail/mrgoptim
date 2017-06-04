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
    . 1      1     0     1 0.000000 2.540978 9.891878 0.4786381
    . 2      1     1     1 3.356629 2.540978 9.891878 0.4786381
    . 3      1     2     1 4.676091 2.540978 9.891878 0.4786381
    . 4      1     3     1 4.905527 2.540978 9.891878 0.4786381
    . 5      1     4     1 4.592786 2.540978 9.891878 0.4786381
    . 6      1     5     1 4.047152 2.540978 9.891878 0.4786381
    . 7      1     6     1 3.436916 2.540978 9.891878 0.4786381
    . 8      1     7     1 2.848303 2.540978 9.891878 0.4786381
    . 9      1     8     1 2.320772 2.540978 9.891878 0.4786381
    . 10     1     9     1 1.867972 2.540978 9.891878 0.4786381
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.628773 16.56495
    . 2      1     1     1 3.605163 1.628773 16.56495
    . 3      1     2     1 4.593816 1.628773 16.56495
    . 4      1     3     1 4.651524 1.628773 16.56495
    . 5      1     4     1 4.395413 1.628773 16.56495
    . 6      1     5     1 4.049827 1.628773 16.56495
    . 7      1     6     1 3.694864 1.628773 16.56495
    . 8      1     7     1 3.357787 1.628773 16.56495
    . 9      1     8     1 3.046627 1.628773 16.56495
    . 10     1     9     1 2.762529 1.628773 16.56495
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
    . 1      1     0 2.179007 8.873215 0.000000
    . 2      1     1 2.179007 8.873215 6.190098
    . 3      1     2 2.179007 8.873215 7.119461
    . 4      1     3 2.179007 8.873215 6.406990
    . 5      1     4 2.179007 8.873215 5.320103
    . 6      1     5 2.179007 8.873215 4.275066
    . 7      1     6 2.179007 8.873215 3.385911
    . 8      1     7 2.179007 8.873215 2.663998
    . 9      1     8 2.179007 8.873215 2.089577
    . 10     1     9 2.179007 8.873215 1.636664
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL         VC
    .    <dbl>    <dbl>      <dbl>
    . 1      1 2.179007   8.873215
    . 2      2 2.075580  66.945042
    . 3      3 2.625162  74.652518
    . 4      4 1.905269  64.824463
    . 5      5 1.134706  87.330607
    . 6      6 3.468401  51.283447
    . 7      7 1.553875 110.835919
    . 8      8 2.589142  86.587802
    . 9      9 2.806394  64.266538
    . 10    10 1.943299  51.621946
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
  sum((dv-pred)^2)
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
              log_par("KA1",1.9,fixed=TRUE))
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
    .    CL 0.0418986    log  u   
    .    VC 0.4551193    log  u   
    .   KA1 1.9000000    log  u  *

``` r
fit$value
```

    . [1] 0.4362742

``` r
fitt$value
```

    . [1] 1.235177
