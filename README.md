
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
    .  1  1.00 0     0      2.99  38.5 0.259 multivariate  1.00
    .  2  1.00 0.250 0.161  2.99  38.5 0.259 multivariate  1.00
    .  3  1.00 0.500 0.309  2.99  38.5 0.259 multivariate  1.00
    .  4  1.00 0.750 0.445  2.99  38.5 0.259 multivariate  1.00
    .  5  1.00 1.00  0.569  2.99  38.5 0.259 multivariate  1.00
    .  6  1.00 1.25  0.683  2.99  38.5 0.259 multivariate  1.00
    .  7  1.00 1.50  0.786  2.99  38.5 0.259 multivariate  1.00
    .  8  1.00 1.75  0.880  2.99  38.5 0.259 multivariate  1.00
    .  9  1.00 2.00  0.966  2.99  38.5 0.259 multivariate  1.00
    . 10  1.00 2.25  1.04   2.99  38.5 0.259 multivariate  1.00
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
    .  1  1.00 0      0    CL     2.39
    .  2  1.00 0.250  1.09 CL     2.39
    .  3  1.00 0.500  1.90 CL     2.39
    .  4  1.00 0.750  2.51 CL     2.39
    .  5  1.00 1.00   2.95 CL     2.39
    .  6  1.00 1.25   3.26 CL     2.39
    .  7  1.00 1.50   3.48 CL     2.39
    .  8  1.00 1.75   3.62 CL     2.39
    .  9  1.00 2.00   3.70 CL     2.39
    . 10  1.00 2.25   3.74 CL     2.39
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
    .  1  1.00 0      0    0.992  20.5 multivariate  1.00
    .  2  1.00 0.250  1.07 0.992  20.5 multivariate  1.00
    .  3  1.00 0.500  1.89 0.992  20.5 multivariate  1.00
    .  4  1.00 0.750  2.52 0.992  20.5 multivariate  1.00
    .  5  1.00 1.00   3.00 0.992  20.5 multivariate  1.00
    .  6  1.00 1.25   3.35 0.992  20.5 multivariate  1.00
    .  7  1.00 1.50   3.62 0.992  20.5 multivariate  1.00
    .  8  1.00 1.75   3.82 0.992  20.5 multivariate  1.00
    .  9  1.00 2.00   3.96 0.992  20.5 multivariate  1.00
    . 10  1.00 2.25   4.05 0.992  20.5 multivariate  1.00
    . # ... with 1,920 more rows

### `sens_seq`

-   Give a sequence for one or more parameters

``` r
mod %>% sens_seq(CL = seq(2,12,2), VC = seq(30,100,10))
```

    . # A tibble: 2,716 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1  1.00 0      0    CL     2.00
    .  2  1.00 0      0    CL     2.00
    .  3  1.00 0.250  1.09 CL     2.00
    .  4  1.00 0.500  1.91 CL     2.00
    .  5  1.00 0.750  2.53 CL     2.00
    .  6  1.00 1.00   2.98 CL     2.00
    .  7  1.00 1.25   3.31 CL     2.00
    .  8  1.00 1.50   3.54 CL     2.00
    .  9  1.00 1.75   3.70 CL     2.00
    . 10  1.00 2.00   3.80 CL     2.00
    . # ... with 2,706 more rows

### `sens_spaced`

-   Create sets of parameters equally-spaced between two bounds

``` r
mod %>%
  select(CL,VC) %>%
  sens_spaced(.n = 5, .factor = 4)
```

    . # A tibble: 1,930 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1  1.00 0      0    CL    0.250
    .  2  1.00 0.250  1.10 CL    0.250
    .  3  1.00 0.500  1.96 CL    0.250
    .  4  1.00 0.750  2.62 CL    0.250
    .  5  1.00 1.00   3.14 CL    0.250
    .  6  1.00 1.25   3.53 CL    0.250
    .  7  1.00 1.50   3.84 CL    0.250
    .  8  1.00 1.75   4.07 CL    0.250
    .  9  1.00 2.00   4.25 CL    0.250
    . 10  1.00 2.25   4.39 CL    0.250
    . # ... with 1,920 more rows

or

``` r
mod %>%
  sens_spaced(.n = 5, .factor = 4, CL = c(0.4, 1.5), VC = c(10,50))
```

    . # A tibble: 5,790 x 5
    .       ID  time    CP name  value
    .    <dbl> <dbl> <dbl> <chr> <dbl>
    .  1  1.00 0      0    CL    0.250
    .  2  1.00 0.250  1.10 CL    0.250
    .  3  1.00 0.500  1.96 CL    0.250
    .  4  1.00 0.750  2.62 CL    0.250
    .  5  1.00 1.00   3.14 CL    0.250
    .  6  1.00 1.25   3.53 CL    0.250
    .  7  1.00 1.50   3.84 CL    0.250
    .  8  1.00 1.75   4.07 CL    0.250
    .  9  1.00 2.00   4.25 CL    0.250
    . 10  1.00 2.25   4.39 CL    0.250
    . # ... with 5,780 more rows

### `sens_grid`

-   Like `sens_seq` but performs all combinations

``` r
mod %>%  sens_grid(CL = seq(1,10,1), VC = seq(20,40,5))
```

    . # A tibble: 9,650 x 7
    .       ID  time    CP    CL    VC name         value
    .    <dbl> <dbl> <dbl> <dbl> <dbl> <chr>        <dbl>
    .  1  1.00 0      0     1.00  20.0 multivariate  1.00
    .  2  1.00 0.250  1.10  1.00  20.0 multivariate  1.00
    .  3  1.00 0.500  1.94  1.00  20.0 multivariate  1.00
    .  4  1.00 0.750  2.58  1.00  20.0 multivariate  1.00
    .  5  1.00 1.00   3.07  1.00  20.0 multivariate  1.00
    .  6  1.00 1.25   3.44  1.00  20.0 multivariate  1.00
    .  7  1.00 1.50   3.71  1.00  20.0 multivariate  1.00
    .  8  1.00 1.75   3.91  1.00  20.0 multivariate  1.00
    .  9  1.00 2.00   4.05  1.00  20.0 multivariate  1.00
    . 10  1.00 2.25   4.15  1.00  20.0 multivariate  1.00
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
    .  1  1.00 0     0      2.06  58.0 multivariate  1.00
    .  2  1.00 0.250 0.380  2.06  58.0 multivariate  1.00
    .  3  1.00 0.500 0.672  2.06  58.0 multivariate  1.00
    .  4  1.00 0.750 0.897  2.06  58.0 multivariate  1.00
    .  5  1.00 1.00  1.07   2.06  58.0 multivariate  1.00
    .  6  1.00 1.25  1.20   2.06  58.0 multivariate  1.00
    .  7  1.00 1.50  1.30   2.06  58.0 multivariate  1.00
    .  8  1.00 1.75  1.37   2.06  58.0 multivariate  1.00
    .  9  1.00 2.00  1.42   2.06  58.0 multivariate  1.00
    . 10  1.00 2.25  1.46   2.06  58.0 multivariate  1.00
    . # ... with 19,290 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 x 3
    .       ID    CL    VC
    .    <dbl> <dbl> <dbl>
    .  1  1.00  2.06  58.0
    .  2  2.00  2.75  64.3
    .  3  3.00  2.28  14.9
    .  4  4.00  2.18  50.7
    .  5  5.00  2.16  82.0
    .  6  6.00  2.13  56.5
    .  7  7.00  3.19  65.3
    .  8  8.00  3.04  35.8
    .  9  9.00  2.72 104  
    . 10 10.0   2.52  17.0
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
