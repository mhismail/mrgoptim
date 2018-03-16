
mrgsolvetk
==========

A toolkit to be used with `mrgsolve`

Examples
========

``` r
library(ggplot2)
library(dplyr)
library(mrgsolve)
library(mrgsolvetk)

mod <- mread_cache("pk1cmt",modlib())

mod <- ev(mod, amt=100) %>% Req(CP) %>% update(end = 48, delta = 0.25)

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
out <- 
  mod %>% 
  select(CL,VC,KA1) %>%
  sens_unif(.n=10, lower=0.2, upper=3)

out
```

    . # A tibble: 1,930 x 8
    .       ID  time    CP    CL    VC   KA1 name         value
    .    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>        <dbl>
    .  1    1. 0.     0.    1.17  20.5  1.42 multivariate    1.
    .  2    1. 0.250  1.45  1.17  20.5  1.42 multivariate    1.
    .  3    1. 0.500  2.44  1.17  20.5  1.42 multivariate    1.
    .  4    1. 0.750  3.12  1.17  20.5  1.42 multivariate    1.
    .  5    1. 1.00   3.57  1.17  20.5  1.42 multivariate    1.
    .  6    1. 1.25   3.87  1.17  20.5  1.42 multivariate    1.
    .  7    1. 1.50   4.06  1.17  20.5  1.42 multivariate    1.
    .  8    1. 1.75   4.18  1.17  20.5  1.42 multivariate    1.
    .  9    1. 2.00   4.24  1.17  20.5  1.42 multivariate    1.
    . 10    1. 2.25   4.26  1.17  20.5  1.42 multivariate    1.
    . # ... with 1,920 more rows

``` r
ggplot(out, aes(time, CP, group = ID, col = VC)) + geom_line()
```

![](inst/maintenance/img/README-unnamed-chunk-3-1.png)

We can also make a univariate version of this

``` r
out <- 
  mod %>% 
  select(CL,VC,KA1) %>%
  sens_unif(.n=10, lower=0.2, upper=3, univariate = TRUE)

out
```

    . # A tibble: 5,790 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1    1. 0.     0.   CL     2.94
    .  2    1. 0.250  1.09 CL     2.94
    .  3    1. 0.500  1.89 CL     2.94
    .  4    1. 0.750  2.48 CL     2.94
    .  5    1. 1.00   2.90 CL     2.94
    .  6    1. 1.25   3.20 CL     2.94
    .  7    1. 1.50   3.39 CL     2.94
    .  8    1. 1.75   3.51 CL     2.94
    .  9    1. 2.00   3.58 CL     2.94
    . 10    1. 2.25   3.59 CL     2.94
    . # ... with 5,780 more rows

``` r
ggplot(out, aes(time, CP, group = ID)) + 
  geom_line() + facet_wrap(~name)
```

![](inst/maintenance/img/README-unnamed-chunk-4-1.png)

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% 
  select(CL,VC) %>%
  sens_norm(.n=10, cv=30)
```

    . # A tibble: 1,930 x 7
    .       ID  time    CP    CL    VC name         value
    .    <dbl> <dbl> <dbl> <dbl> <dbl> <chr>        <dbl>
    .  1    1. 0.     0.    1.64  20.5 multivariate    1.
    .  2    1. 0.250  1.07  1.64  20.5 multivariate    1.
    .  3    1. 0.500  1.87  1.64  20.5 multivariate    1.
    .  4    1. 0.750  2.48  1.64  20.5 multivariate    1.
    .  5    1. 1.00   2.94  1.64  20.5 multivariate    1.
    .  6    1. 1.25   3.27  1.64  20.5 multivariate    1.
    .  7    1. 1.50   3.51  1.64  20.5 multivariate    1.
    .  8    1. 1.75   3.68  1.64  20.5 multivariate    1.
    .  9    1. 2.00   3.79  1.64  20.5 multivariate    1.
    . 10    1. 2.25   3.86  1.64  20.5 multivariate    1.
    . # ... with 1,920 more rows

### `sens_seq`

-   Give a sequence for one or more parameters

``` r
mod %>% sens_seq(CL = seq(2,12,2), VC = seq(30,100,10))
```

    . # A tibble: 2,716 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1    1. 0.     0.   CL       2.
    .  2    1. 0.     0.   CL       2.
    .  3    1. 0.250  1.09 CL       2.
    .  4    1. 0.500  1.91 CL       2.
    .  5    1. 0.750  2.53 CL       2.
    .  6    1. 1.00   2.98 CL       2.
    .  7    1. 1.25   3.31 CL       2.
    .  8    1. 1.50   3.54 CL       2.
    .  9    1. 1.75   3.70 CL       2.
    . 10    1. 2.00   3.80 CL       2.
    . # ... with 2,706 more rows

### `sens_range`

-   Create sets of parameters equally-spaced between two bounds

``` r
mod %>%
  select(CL,VC) %>%
  sens_range(.n = 5, .factor = 4)
```

    . # A tibble: 1,930 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1    1. 0.     0.   CL    0.250
    .  2    1. 0.250  1.10 CL    0.250
    .  3    1. 0.500  1.96 CL    0.250
    .  4    1. 0.750  2.62 CL    0.250
    .  5    1. 1.00   3.14 CL    0.250
    .  6    1. 1.25   3.53 CL    0.250
    .  7    1. 1.50   3.84 CL    0.250
    .  8    1. 1.75   4.07 CL    0.250
    .  9    1. 2.00   4.25 CL    0.250
    . 10    1. 2.25   4.39 CL    0.250
    . # ... with 1,920 more rows

or

``` r
out <- 
  mod %>%
  sens_range(CL = c(0.5, 1.5), VC = c(10,40), .n = 5)

ggplot(out, aes(time,CP, group = ID)) + geom_line() + facet_wrap(~name)
```

![](inst/maintenance/img/README-unnamed-chunk-8-1.png)

### `sens_grid`

-   Like `sens_seq` but performs all combinations

``` r
mod %>%  sens_grid(CL = seq(1,10,1), VC = seq(20,40,5))
```

    . # A tibble: 9,650 x 7
    .       ID  time    CP    CL    VC name         value
    .    <dbl> <dbl> <dbl> <dbl> <dbl> <chr>        <dbl>
    .  1    1. 0.     0.      1.   20. multivariate    1.
    .  2    1. 0.250  1.10    1.   20. multivariate    1.
    .  3    1. 0.500  1.94    1.   20. multivariate    1.
    .  4    1. 0.750  2.58    1.   20. multivariate    1.
    .  5    1. 1.00   3.07    1.   20. multivariate    1.
    .  6    1. 1.25   3.44    1.   20. multivariate    1.
    .  7    1. 1.50   3.71    1.   20. multivariate    1.
    .  8    1. 1.75   3.91    1.   20. multivariate    1.
    .  9    1. 2.00   4.05    1.   20. multivariate    1.
    . 10    1. 2.25   4.15    1.   20. multivariate    1.
    . # ... with 9,640 more rows

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

    . # A tibble: 19,300 x 7
    .       ID  time    CP    CL    VC name         value
    .    <dbl> <dbl> <dbl> <dbl> <dbl> <chr>        <dbl>
    .  1    1. 0.    0.     1.77  46.3 multivariate    1.
    .  2    1. 0.250 0.475  1.77  46.3 multivariate    1.
    .  3    1. 0.500 0.841  1.77  46.3 multivariate    1.
    .  4    1. 0.750 1.12   1.77  46.3 multivariate    1.
    .  5    1. 1.00  1.34   1.77  46.3 multivariate    1.
    .  6    1. 1.25  1.50   1.77  46.3 multivariate    1.
    .  7    1. 1.50  1.62   1.77  46.3 multivariate    1.
    .  8    1. 1.75  1.71   1.77  46.3 multivariate    1.
    .  9    1. 2.00  1.78   1.77  46.3 multivariate    1.
    . 10    1. 2.25  1.82   1.77  46.3 multivariate    1.
    . # ... with 19,290 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 x 3
    .       ID    CL    VC
    .    <dbl> <dbl> <dbl>
    .  1    1.  1.77  46.3
    .  2    2.  1.54  66.4
    .  3    3.  3.18  69.1
    .  4    4.  1.35  68.8
    .  5    5.  3.03  81.1
    .  6    6.  1.39  66.5
    .  7    7.  1.41  19.9
    .  8    8.  3.16 126. 
    .  9    9.  1.94  21.9
    . 10   10.  2.80  15.1
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

-   This could be anything

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

-   The workflow is the same as when we simulate
-   Get the model ready
-   Define the dta set
-   Pipe to `fit_optim` rather than `mrgsim`
-   Here, just fit `ID==3`

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

![](inst/maintenance/img/README-unnamed-chunk-19-1.png)

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
