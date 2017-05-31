mrgsolvetk
==========

A toolkit to be used with `mrgsolve`

Examples
========

``` r
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
    .       ID  time    .n       CP       CL      VC      KA1
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>   <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.617274 52.5965 2.674642
    . 2      1     1     1 1.755731 0.617274 52.5965 2.674642
    . 3      1     2     1 1.856271 0.617274 52.5965 2.674642
    . 4      1     3     1 1.842956 0.617274 52.5965 2.674642
    . 5      1     4     1 1.822028 0.617274 52.5965 2.674642
    . 6      1     5     1 1.800810 0.617274 52.5965 2.674642
    . 7      1     6     1 1.779802 0.617274 52.5965 2.674642
    . 8      1     7     1 1.759036 0.617274 52.5965 2.674642
    . 9      1     8     1 1.738513 0.617274 52.5965 2.674642
    . 10     1     9     1 1.718229 0.617274 52.5965 2.674642
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.8834262 22.74847
    . 2      1     1     1 2.716804 0.8834262 22.74847
    . 3      1     2     1 3.612777 0.8834262 22.74847
    . 4      1     3     1 3.842845 0.8834262 22.74847
    . 5      1     4     1 3.831733 0.8834262 22.74847
    . 6      1     5     1 3.735541 0.8834262 22.74847
    . 7      1     6     1 3.611560 0.8834262 22.74847
    . 8      1     7     1 3.480729 0.8834262 22.74847
    . 9      1     8     1 3.350625 0.8834262 22.74847
    . 10     1     9     1 3.223911 0.8834262 22.74847
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
