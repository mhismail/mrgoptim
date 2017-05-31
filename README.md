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
    .       ID  time    .n       CP       CL       VC      KA1
    .    <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0     1 0.000000 1.691399 59.49087 2.939968
    . 2      1     1     1 1.560032 1.691399 59.49087 2.939968
    . 3      1     2     1 1.598778 1.691399 59.49087 2.939968
    . 4      1     3     1 1.558323 1.691399 59.49087 2.939968
    . 5      1     4     1 1.514873 1.691399 59.49087 2.939968
    . 6      1     5     1 1.472422 1.691399 59.49087 2.939968
    . 7      1     6     1 1.431149 1.691399 59.49087 2.939968
    . 8      1     7     1 1.391033 1.691399 59.49087 2.939968
    . 9      1     8     1 1.352041 1.691399 59.49087 2.939968
    . 10     1     9     1 1.314142 1.691399 59.49087 2.939968
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.8733277 26.06005
    . 2      1     1     1 2.378887 0.8733277 26.06005
    . 3      1     2     1 3.175630 0.8733277 26.06005
    . 4      1     3     1 3.392919 0.8733277 26.06005
    . 5      1     4     1 3.399537 0.8733277 26.06005
    . 6      1     5     1 3.331070 0.8733277 26.06005
    . 7      1     6     1 3.237317 0.8733277 26.06005
    . 8      1     7     1 3.136522 0.8733277 26.06005
    . 9      1     8     1 3.035322 0.8733277 26.06005
    . 10     1     9     1 2.936085 0.8733277 26.06005
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
out <- 
  mod %>% sens_covset(cov1) 
```

``` r
out
```

    . # A tibble: 2,500 × 5
    .       ID  time       CL       VC       CP
    .    <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0 2.498611 27.77209 0.000000
    . 2      1     1 2.498611 27.77209 2.160687
    . 3      1     2 2.498611 27.77209 2.769653
    . 4      1     3 2.498611 27.77209 2.823770
    . 5      1     4 2.498611 27.77209 2.688387
    . 6      1     5 2.498611 27.77209 2.496653
    . 7      1     6 2.498611 27.77209 2.296399
    . 8      1     7 2.498611 27.77209 2.104173
    . 9      1     8 2.498611 27.77209 1.925100
    . 10     1     9 2.498611 27.77209 1.760190
    . # ... with 2,490 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL        VC
    .    <dbl>    <dbl>     <dbl>
    . 1      1 2.498611  27.77209
    . 2      2 1.827693  20.53328
    . 3      3 1.784695 123.68407
    . 4      4 2.987788  22.57002
    . 5      5 3.430726  69.43593
    . 6      6 2.167491  64.02380
    . 7      7 1.879030  29.17437
    . 8      8 1.859437  20.83100
    . 9      9 1.742493  70.94655
    . 10    10 1.927185  42.05558
    . # ... with 90 more rows
