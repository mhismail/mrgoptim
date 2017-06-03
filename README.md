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
    . 1      1     0     1 0.000000 0.957324 40.77757 0.9994876
    . 2      1     1     1 1.528710 0.957324 40.77757 0.9994876
    . 3      1     2     1 2.055908 0.957324 40.77757 0.9994876
    . 4      1     3     1 2.215305 0.957324 40.77757 0.9994876
    . 5      1     4     1 2.240130 0.957324 40.77757 0.9994876
    . 6      1     5     1 2.216208 0.957324 40.77757 0.9994876
    . 7      1     6     1 2.175112 0.957324 40.77757 0.9994876
    . 8      1     7     1 2.128443 0.957324 40.77757 0.9994876
    . 9      1     8     1 2.080455 0.957324 40.77757 0.9994876
    . 10     1     9     1 2.032696 0.957324 40.77757 0.9994876
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.129167 16.35287
    . 2      1     1     1 3.713949 1.129167 16.35287
    . 3      1     2     1 4.832440 1.129167 16.35287
    . 4      1     3     1 5.012647 1.129167 16.35287
    . 5      1     4     1 4.863110 1.129167 16.35287
    . 6      1     5     1 4.606666 1.129167 16.35287
    . 7      1     6     1 4.324334 1.129167 16.35287
    . 8      1     7     1 4.045020 1.129167 16.35287
    . 9      1     8     1 3.778523 1.129167 16.35287
    . 10     1     9     1 3.527666 1.129167 16.35287
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
    . 1      1     0 1.300061 69.52119 0.0000000
    . 2      1     1 1.300061 69.52119 0.8994194
    . 3      1     2 1.300061 69.52119 1.2136343
    . 4      1     3 1.300061 69.52119 1.3128732
    . 5      1     4 1.300061 69.52119 1.3333297
    . 6      1     5 1.300061 69.52119 1.3251013
    . 7      1     6 1.300061 69.52119 1.3066122
    . 8      1     7 1.300061 69.52119 1.2846347
    . 9      1     8 1.300061 69.52119 1.2616552
    . 10     1     9 1.300061 69.52119 1.2385829
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 1.300061 69.52119
    . 2      2 2.939649 72.18665
    . 3      3 1.862759 68.25833
    . 4      4 2.210810 68.79057
    . 5      5 1.040438 76.44520
    . 6      6 1.540675 40.96799
    . 7      7 2.067978 56.00833
    . 8      8 1.058013 58.92318
    . 9      9 1.513768 69.17408
    . 10    10 3.429093 32.93340
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

Fit
---

``` r
fit <- 
  mod %>% 
  Req(CP) %>% 
  data_set(id1) %>%
  fit_optim(pred="CP",.ofv=ofv,par=log(c(CL=0.1, VC=1,KA1=2)))
```

Plot
----

``` r
library(ggplot2)
ggplot(data=fit$tab) + 
  geom_point(aes(time,conc)) +
  geom_line(aes(time,PRED)) 
```

![](inst/maintenance/img/README-unnamed-chunk-14-1.png)
