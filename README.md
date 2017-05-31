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
    . 1      1     0     1 0.0000000 2.308269 58.63707 0.2351178
    . 2      1     1     1 0.3501089 2.308269 58.63707 0.2351178
    . 3      1     2     1 0.6133478 2.308269 58.63707 0.2351178
    . 4      1     3     1 0.8084395 2.308269 58.63707 0.2351178
    . 5      1     4     1 0.9501640 2.308269 58.63707 0.2351178
    . 6      1     5     1 1.0501850 2.308269 58.63707 0.2351178
    . 7      1     6     1 1.1177038 2.308269 58.63707 0.2351178
    . 8      1     7     1 1.1599761 2.308269 58.63707 0.2351178
    . 9      1     8     1 1.1827201 2.308269 58.63707 0.2351178
    . 10     1     9     1 1.1904392 2.308269 58.63707 0.2351178
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.355427 25.55826
    . 2      1     1     1 2.398354 1.355427 25.55826
    . 3      1     2     1 3.156781 1.355427 25.55826
    . 4      1     3     1 3.318311 1.355427 25.55826
    . 5      1     4     1 3.266324 1.355427 25.55826
    . 6      1     5     1 3.141542 1.355427 25.55826
    . 7      1     6     1 2.995438 1.355427 25.55826
    . 8      1     7     1 2.846665 1.355427 25.55826
    . 9      1     8     1 2.701818 1.355427 25.55826
    . 10     1     9     1 2.563071 1.355427 25.55826
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
    . 1      1     0 2.077896 43.29456 0.000000
    . 2      1     1 2.077896 43.29456 1.419959
    . 3      1     2 2.077896 43.29456 1.875792
    . 4      1     3 2.077896 43.29456 1.980061
    . 5      1     4 2.077896 43.29456 1.957970
    . 6      1     5 2.077896 43.29456 1.892225
    . 7      1     6 2.077896 43.29456 1.813121
    . 8      1     7 2.077896 43.29456 1.731677
    . 9      1     8 2.077896 43.29456 1.651824
    . 10     1     9 2.077896 43.29456 1.574894
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 2.077896 43.29456
    . 2      2 2.719973 67.86942
    . 3      3 1.836097 30.21579
    . 4      4 3.154695 17.41624
    . 5      5 1.748545 37.93383
    . 6      6 2.213335 55.29779
    . 7      7 3.363827 63.05962
    . 8      8 2.141097 71.05461
    . 9      9 1.239099 48.59677
    . 10    10 3.380694 50.39964
    . # ... with 90 more rows
