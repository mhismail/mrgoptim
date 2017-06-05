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
    .       ID  time    .n        CP        CL       VC       KA1
    .    <dbl> <dbl> <dbl>     <dbl>     <dbl>    <dbl>     <dbl>
    . 1      1     0     1  0.000000 0.3831035 7.698236 0.6232951
    . 2      1     1     1  5.862534 0.3831035 7.698236 0.6232951
    . 3      1     2     1  8.721268 0.3831035 7.698236 0.6232951
    . 4      1     3     1  9.983257 0.3831035 7.698236 0.6232951
    . 5      1     4     1 10.402257 0.3831035 7.698236 0.6232951
    . 6      1     5     1 10.381777 0.3831035 7.698236 0.6232951
    . 7      1     6     1 10.137559 0.3831035 7.698236 0.6232951
    . 8      1     7     1  9.784701 0.3831035 7.698236 0.6232951
    . 9      1     8     1  9.384366 0.3831035 7.698236 0.6232951
    . 10     1     9     1  8.968826 0.3831035 7.698236 0.6232951
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.9024271 17.26449
    . 2      1     1     1 3.552074 0.9024271 17.26449
    . 3      1     2     1 4.677909 0.9024271 17.26449
    . 4      1     3     1 4.920392 0.9024271 17.26449
    . 5      1     4     1 4.846654 0.9024271 17.26449
    . 6      1     5     1 4.664881 0.9024271 17.26449
    . 7      1     6     1 4.451241 0.9024271 17.26449
    . 8      1     7     1 4.233353 0.9024271 17.26449
    . 9      1     8     1 4.020995 0.9024271 17.26449
    . 10     1     9     1 3.817405 0.9024271 17.26449
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
    .       ID  time       CL       VC        CP
    .    <dbl> <dbl>    <dbl>    <dbl>     <dbl>
    . 1      1     0 1.073724 100.3893 0.0000000
    . 2      1     1 1.073724 100.3893 0.6257648
    . 3      1     2 1.073724 100.3893 0.8493135
    . 4      1     3 1.073724 100.3893 0.9249660
    . 5      1     4 1.073724 100.3893 0.9462807
    . 6      1     5 1.073724 100.3893 0.9476748
    . 7      1     6 1.073724 100.3893 0.9418093
    . 8      1     7 1.073724 100.3893 0.9333408
    . 9      1     8 1.073724 100.3893 0.9239820
    . 10     1     9 1.073724 100.3893 0.9143620
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL        VC
    .    <dbl>    <dbl>     <dbl>
    . 1      1 1.073724 100.38931
    . 2      2 1.824584  61.23770
    . 3      3 3.433641  28.71358
    . 4      4 3.351186  13.71825
    . 5      5 2.197398  31.55490
    . 6      6 2.876671  30.28600
    . 7      7 1.818583  30.56001
    . 8      8 2.388904  24.30518
    . 9      9 3.462012  38.17118
    . 10    10 1.775714  47.33401
    . # ... with 90 more rows

Estimation `stats::optim`
=========================

Load a data set
---------------

``` r
data(exTheoph)
df <- mutate(exTheoph, DV = conc)
```

Load a model
------------

``` r
mod <- mread("pk1cmt", modlib())
```

Define an objective function
----------------------------

``` r
ofv <- function(dv,pred,par) -1*sum(dnorm(dv,pred,par$sigma,log=TRUE))
```

Define parameters to estimate
-----------------------------

``` r
library(optimhelp)
par <- parset(log_par("CL", 0.1),
              log_par("VC", 1.1),
              log_par("KA1",1.1),
              log_par("sigma",1))
```

Fit
---

-   `ID==3`

``` r
fit <- 
  mod %>% 
  data_set(df, ID==3) %>%
  fit_optim(pred="CP",ofv=ofv,par=par)
```

``` r
fit$pars
```

    .   name     value transf tr fx
    .     CL 0.0395583    log  u   
    .     VC 0.4858379    log  u   
    .    KA1 2.4536472    log  u   
    .  sigma 0.2089564    log  u

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
              log_par("KA1",1.9,fixed=TRUE),
              log_par("sigma",1))
```

Fit
---

``` r
fitt <- 
  mod %>% 
  data_set(df, ID==3) %>%
  fit_optim(pred="CP",ofv=ofv,par=par)
```

``` r
fitt$pars
```

    .   name      value transf tr fx
    .     CL 0.04190059    log  u   
    .     VC 0.45512514    log  u   
    .    KA1 1.90000000    log  u  *
    .  sigma 0.35140850    log  u

``` r
fit$value
```

    . [1] -1.470963

``` r
fitt$value
```

    . [1] 3.732531
