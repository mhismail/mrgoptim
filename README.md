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
    .       ID  time    .n        CP       CL       VC       KA1
    .    <dbl> <dbl> <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    . 1      1     0     1 0.0000000 1.021969 23.53761 0.2209016
    . 2      1     1     1 0.8233982 1.021969 23.53761 0.2209016
    . 3      1     2     1 1.4486096 1.021969 23.53761 0.2209016
    . 4      1     3     1 1.9164020 1.021969 23.53761 0.2209016
    . 5      1     4     1 2.2594000 1.021969 23.53761 0.2209016
    . 6      1     5     1 2.5037014 1.021969 23.53761 0.2209016
    . 7      1     6     1 2.6701731 1.021969 23.53761 0.2209016
    . 8      1     7     1 2.7754909 1.021969 23.53761 0.2209016
    . 9      1     8     1 2.8329722 1.021969 23.53761 0.2209016
    . 10     1     9     1 2.8532441 1.021969 23.53761 0.2209016
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.529401 19.25196
    . 2      1     1     1 3.135849 1.529401 19.25196
    . 3      1     2     1 4.049986 1.529401 19.25196
    . 4      1     3     1 4.165089 1.529401 19.25196
    . 5      1     4     1 4.003135 1.529401 19.25196
    . 6      1     5     1 3.754859 1.529401 19.25196
    . 7      1     6     1 3.489238 1.529401 19.25196
    . 8      1     7     1 3.230546 1.529401 19.25196
    . 9      1     8     1 2.986696 1.529401 19.25196
    . 10     1     9     1 2.759660 1.529401 19.25196
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
    . 1      1     0 1.426854 55.70027 0.000000
    . 2      1     1 1.426854 55.70027 1.118097
    . 3      1     2 1.426854 55.70027 1.501143
    . 4      1     3 1.426854 55.70027 1.614495
    . 5      1     4 1.426854 55.70027 1.629329
    . 6      1     5 1.426854 55.70027 1.608600
    . 7      1     6 1.426854 55.70027 1.575450
    . 8      1     7 1.426854 55.70027 1.538376
    . 9      1     8 1.426854 55.70027 1.500488
    . 10     1     9 1.426854 55.70027 1.462914
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 1.426854 55.70027
    . 2      2 2.712826 54.82655
    . 3      3 1.096866 49.54702
    . 4      4 1.658505 43.50006
    . 5      5 3.207685 34.28758
    . 6      6 2.479760 51.70614
    . 7      7 2.702300 21.17514
    . 8      8 1.878402 24.17110
    . 9      9 1.962352 56.28122
    . 10    10 3.155458 85.06298
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
ofv <- function(dv,pred,par) sum((pred-dv)^2)
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
