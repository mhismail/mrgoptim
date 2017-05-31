mrgsolvetk
==========

A toolkit to be used with `mrgsolve`

Examples
========

``` r
library(mrgsolve)
library(mrgsolvetk)
```

    . Loading required package: MASS

``` r
mod <- mread_cache("pk1cmt",modlib())
```

    . Compiling pk1cmt ...

    . done.

``` r
mod <- ev(mod, amt=100) %>% Req(CP)
```

Sensitivity analyses
--------------------

### `sens_unif`

-   Draw parameters from uniform distribution based on current parameter values

``` r
mod %>% sens_unif(n=10, pars="CL,VC,KA1", lower=0.2, upper=3)
```

    . # A tibble: 250 × 7
    .       ID  time    .n       CP       CL       VC     KA1
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>   <dbl>
    . 1      1     0     1 0.000000 2.449362 28.91923 2.70549
    . 2      1     1     1 3.041181 2.449362 28.91923 2.70549
    . 3      1     2     1 2.997475 2.449362 28.91923 2.70549
    . 4      1     3     1 2.767639 2.449362 28.91923 2.70549
    . 5      1     4     1 2.543789 2.449362 28.91923 2.70549
    . 6      1     5     1 2.337271 2.449362 28.91923 2.70549
    . 7      1     6     1 2.147468 2.449362 28.91923 2.70549
    . 8      1     7     1 1.973074 2.449362 28.91923 2.70549
    . 9      1     8     1 1.812843 2.449362 28.91923 2.70549
    . 10     1     9     1 1.665623 2.449362 28.91923 2.70549
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP       CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.142114 18.30616
    . 2      1     1     1 3.330434 1.142114 18.30616
    . 3      1     2     1 4.354197 1.142114 18.30616
    . 4      1     3     1 4.541566 1.142114 18.30616
    . 5      1     4     1 4.432691 1.142114 18.30616
    . 6      1     5     1 4.225586 1.142114 18.30616
    . 7      1     6     1 3.992450 1.142114 18.30616
    . 8      1     7     1 3.759229 1.142114 18.30616
    . 9      1     8     1 3.534896 1.142114 18.30616
    . 10     1     9     1 3.322211 1.142114 18.30616
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
