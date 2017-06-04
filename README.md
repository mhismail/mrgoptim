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
    .       ID  time    .n       CP        CL       VC      KA1
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.4434313 9.819668 1.197894
    . 2      1     1     1 6.921196 0.4434313 9.819668 1.197894
    . 3      1     2     1 8.704623 0.4434313 9.819668 1.197894
    . 4      1     3     1 8.950813 0.4434313 9.819668 1.197894
    . 5      1     4     1 8.745919 0.4434313 9.819668 1.197894
    . 6      1     5     1 8.417201 0.4434313 9.819668 1.197894
    . 7      1     6     1 8.062894 0.4434313 9.819668 1.197894
    . 8      1     7     1 7.712126 0.4434313 9.819668 1.197894
    . 9      1     8     1 7.373191 0.4434313 9.819668 1.197894
    . 10     1     9     1 7.048119 0.4434313 9.819668 1.197894
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL      VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>   <dbl>
    . 1      1     0     1 0.000000 1.127595 25.5512
    . 2      1     1     1 2.411394 1.127595 25.5512
    . 3      1     2     1 3.194393 1.127595 25.5512
    . 4      1     3     1 3.382834 1.127595 25.5512
    . 5      1     4     1 3.356849 1.127595 25.5512
    . 6      1     5     1 3.256096 1.127595 25.5512
    . 7      1     6     1 3.131774 1.127595 25.5512
    . 8      1     7     1 3.002549 1.127595 25.5512
    . 9      1     8     1 2.875124 1.127595 25.5512
    . 10     1     9     1 2.751811 1.127595 25.5512
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
    . 1      1     0 1.329021 43.57533 0.000000
    . 2      1     1 1.329021 43.57533 1.425170
    . 3      1     2 1.329021 43.57533 1.906650
    . 4      1     3 1.329021 43.57533 2.042252
    . 5      1     4 1.329021 43.57533 2.051860
    . 6      1     5 1.329021 43.57533 2.016327
    . 7      1     6 1.329021 43.57533 1.965361
    . 8      1     7 1.329021 43.57533 1.909856
    . 9      1     8 1.329021 43.57533 1.853786
    . 10     1     9 1.329021 43.57533 1.798578
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL        VC
    .    <dbl>    <dbl>     <dbl>
    . 1      1 1.329021 43.575328
    . 2      2 2.741465 60.222557
    . 3      3 1.707627 45.508775
    . 4      4 1.484116  8.648676
    . 5      5 2.569538 45.906858
    . 6      6 3.175686 81.474069
    . 7      7 2.404282 47.686904
    . 8      8 2.004302 78.861394
    . 9      9 1.899636 71.350182
    . 10    10 1.555439 48.301139
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

-   `ID==3`

``` r
fit <- 
  mod %>% 
  data_set(df, ID==3) %>%
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
  data_set(df, ID==3) %>%
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
