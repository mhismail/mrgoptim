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
    . 1      1     0     1 0.0000000 0.2591618 54.38344 0.4562818
    . 2      1     1     1 0.6719457 0.2591618 54.38344 0.4562818
    . 3      1     2     1 1.0945197 0.2591618 54.38344 0.4562818
    . 4      1     3     1 1.3590982 0.2591618 54.38344 0.4562818
    . 5      1     4     1 1.5235802 0.2591618 54.38344 0.4562818
    . 6      1     5     1 1.6246527 0.2591618 54.38344 0.4562818
    . 7      1     6     1 1.6855615 0.2591618 54.38344 0.4562818
    . 8      1     7     1 1.7210363 0.2591618 54.38344 0.4562818
    . 9      1     8     1 1.7404098 0.2591618 54.38344 0.4562818
    . 10     1     9     1 1.7495959 0.2591618 54.38344 0.4562818
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.885752 20.36215
    . 2      1     1     1 3.027013 0.885752 20.36215
    . 3      1     2     1 4.011737 0.885752 20.36215
    . 4      1     3     1 4.250630 0.885752 20.36215
    . 5      1     4     1 4.220398 0.885752 20.36215
    . 6      1     5     1 4.096188 0.885752 20.36215
    . 7      1     6     1 3.942220 0.885752 20.36215
    . 8      1     7     1 3.781913 0.885752 20.36215
    . 9      1     8     1 3.623688 0.885752 20.36215
    . 10     1     9     1 3.470452 0.885752 20.36215
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
    .       ID  time       CL      VC       CP
    .    <dbl> <dbl>    <dbl>   <dbl>    <dbl>
    . 1      1     0 2.346612 52.0839 0.000000
    . 2      1     1 2.346612 52.0839 1.182344
    . 3      1     2 2.346612 52.0839 1.565217
    . 4      1     3 2.346612 52.0839 1.656275
    . 5      1     4 2.346612 52.0839 1.642174
    . 6      1     5 2.346612 52.0839 1.591484
    . 7      1     6 2.346612 52.0839 1.529338
    . 8      1     7 2.346612 52.0839 1.464895
    . 9      1     8 2.346612 52.0839 1.401438
    . 10     1     9 2.346612 52.0839 1.340094
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 2.346612 52.08390
    . 2      2 1.588635 36.93333
    . 3      3 2.056213 15.31645
    . 4      4 3.496802 75.21378
    . 5      5 1.327441 72.60320
    . 6      6 1.792754 49.85540
    . 7      7 1.518249 21.71990
    . 8      8 3.212260 83.95119
    . 9      9 3.067394 34.74384
    . 10    10 2.157742 29.85984
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
