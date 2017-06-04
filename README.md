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
    . 1      1     0     1 0.000000 0.3382375 47.47066 2.076973
    . 2      1     1     1 1.833928 0.3382375 47.47066 2.076973
    . 3      1     2     1 2.050715 0.3382375 47.47066 2.076973
    . 4      1     3     1 2.064952 0.3382375 47.47066 2.076973
    . 5      1     4     1 2.053900 0.3382375 47.47066 2.076973
    . 6      1     5     1 2.039770 0.3382375 47.47066 2.076973
    . 7      1     6     1 2.025344 0.3382375 47.47066 2.076973
    . 8      1     7     1 2.010972 0.3382375 47.47066 2.076973
    . 9      1     8     1 1.996695 0.3382375 47.47066 2.076973
    . 10     1     9     1 1.982519 0.3382375 47.47066 2.076973
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP      CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>   <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.44412 15.16759
    . 2      1     1     1 3.944351 1.44412 15.16759
    . 3      1     2     1 5.037175 1.44412 15.16759
    . 4      1     3     1 5.113515 1.44412 15.16759
    . 5      1     4     1 4.845489 1.44412 15.16759
    . 6      1     5     1 4.477670 1.44412 15.16759
    . 7      1     6     1 4.097590 1.44412 15.16759
    . 8      1     7     1 3.735228 1.44412 15.16759
    . 9      1     8     1 3.399596 1.44412 15.16759
    . 10     1     9     1 3.092172 1.44412 15.16759
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
    . 1      1     0 2.949954 56.7621 0.000000
    . 2      1     1 2.949954 56.7621 1.080569
    . 3      1     2 2.949954 56.7621 1.423365
    . 4      1     3 2.949954 56.7621 1.497520
    . 5      1     4 2.949954 56.7621 1.475480
    . 6      1     5 2.949954 56.7621 1.420548
    . 7      1     6 2.949954 56.7621 1.355888
    . 8      1     7 2.949954 56.7621 1.289900
    . 9      1     8 2.949954 56.7621 1.225561
    . 10     1     9 2.949954 56.7621 1.163857
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 2.949954 56.76210
    . 2      2 1.557767 43.05566
    . 3      3 1.837909 23.02089
    . 4      4 2.279251 35.65054
    . 5      5 3.415996 30.82367
    . 6      6 2.197887 30.61107
    . 7      7 1.266501 47.29215
    . 8      8 1.802768 43.53402
    . 9      9 1.325336 76.72148
    . 10    10 2.742595 53.89376
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
