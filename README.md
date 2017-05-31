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
```

Sensitivity analyses
--------------------

### `sens_unif`

-   Draw parameters from uniform distribution based on current parameter values

``` r
mod %>% sens_unif(n=10, pars="CL,VC,KA1", lower=0.2, upper=3)
```

    . # A tibble: 250 × 7
    .       ID  time    .n       CP      CL       VC      KA1
    .    <dbl> <dbl> <dbl>    <dbl>   <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.27668 20.33187 2.755457
    . 2      1     1     1 4.561728 0.27668 20.33187 2.755457
    . 3      1     2     1 4.790106 0.27668 20.33187 2.755457
    . 4      1     3     1 4.743803 0.27668 20.33187 2.755457
    . 5      1     4     1 4.680858 0.27668 20.33187 2.755457
    . 6      1     5     1 4.617666 0.27668 20.33187 2.755457
    . 7      1     6     1 4.555258 0.27668 20.33187 2.755457
    . 8      1     7     1 4.493690 0.27668 20.33187 2.755457
    . 9      1     8     1 4.432953 0.27668 20.33187 2.755457
    . 10     1     9     1 4.373037 0.27668 20.33187 2.755457
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.5678888 38.08874
    . 2      1     1     1 1.645276 0.5678888 38.08874
    . 3      1     2     1 2.226191 0.5678888 38.08874
    . 4      1     3     1 2.415909 0.5678888 38.08874
    . 5      1     4     1 2.462070 0.5678888 38.08874
    . 6      1     5     1 2.455768 0.5678888 38.08874
    . 7      1     6     1 2.430511 0.5678888 38.08874
    . 8      1     7     1 2.398620 0.5678888 38.08874
    . 9      1     8     1 2.364623 0.5678888 38.08874
    . 10     1     9     1 2.330180 0.5678888 38.08874
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
