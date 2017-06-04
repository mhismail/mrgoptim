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
    .       ID  time    .n       CP      CL       VC      KA1
    .    <dbl> <dbl> <dbl>    <dbl>   <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.21772 32.37781 2.692565
    . 2      1     1     1 2.804592 1.21772 32.37781 2.692565
    . 3      1     2     1 2.890962 1.21772 32.37781 2.692565
    . 4      1     3     1 2.797110 1.21772 32.37781 2.692565
    . 5      1     4     1 2.694735 1.21772 32.37781 2.692565
    . 6      1     5     1 2.595328 1.21772 32.37781 2.692565
    . 7      1     6     1 2.499535 1.21772 32.37781 2.692565
    . 8      1     7     1 2.407275 1.21772 32.37781 2.692565
    . 9      1     8     1 2.318419 1.21772 32.37781 2.692565
    . 10     1     9     1 2.232843 1.21772 32.37781 2.692565
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.7138531 14.65374
    . 2      1     1     1 4.193530 0.7138531 14.65374
    . 3      1     2     1 5.536852 0.7138531 14.65374
    . 4      1     3     1 5.841123 0.7138531 14.65374
    . 5      1     4     1 5.772178 0.7138531 14.65374
    . 6      1     5     1 5.574534 0.7138531 14.65374
    . 7      1     6     1 5.337736 0.7138531 14.65374
    . 8      1     7     1 5.094336 0.7138531 14.65374
    . 9      1     8     1 4.855939 0.7138531 14.65374
    . 10     1     9     1 4.626459 0.7138531 14.65374
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
    . 1      1     0 2.920793 12.49237 0.000000
    . 2      1     1 2.920793 12.49237 4.425977
    . 3      1     2 2.920793 12.49237 5.131454
    . 4      1     3 2.920793 12.49237 4.660615
    . 5      1     4 2.920793 12.49237 3.909304
    . 6      1     5 2.920793 12.49237 3.175339
    . 7      1     6 2.920793 12.49237 2.543151
    . 8      1     7 2.920793 12.49237 2.023914
    . 9      1     8 2.920793 12.49237 1.605995
    . 10     1     9 2.920793 12.49237 1.272654
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL        VC
    .    <dbl>    <dbl>     <dbl>
    . 1      1 2.920793  12.49237
    . 2      2 2.962047  38.57340
    . 3      3 1.285852  47.15309
    . 4      4 1.480744  60.17297
    . 5      5 2.628013  91.70701
    . 6      6 2.452600  47.21852
    . 7      7 3.361225 111.59715
    . 8      8 2.148507  74.36418
    . 9      9 2.341086  47.81903
    . 10    10 2.871141  60.98807
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
ofv <- function(dv,pred,par) sum((dv-pred)^2)
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
