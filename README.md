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
    . 1      1     0     1 0.000000 1.753753 48.59518 1.561857
    . 2      1     1     1 1.589997 1.753753 48.59518 1.561857
    . 3      1     2     1 1.867134 1.753753 48.59518 1.561857
    . 4      1     3     1 1.870902 1.753753 48.59518 1.561857
    . 5      1     4     1 1.819258 1.753753 48.59518 1.561857
    . 6      1     5     1 1.757851 1.753753 48.59518 1.561857
    . 7      1     6     1 1.696188 1.753753 48.59518 1.561857
    . 8      1     7     1 1.636201 1.753753 48.59518 1.561857
    . 9      1     8     1 1.578233 1.753753 48.59518 1.561857
    . 10     1     9     1 1.522298 1.753753 48.59518 1.561857
    . # ... with 240 more rows

### `sens_norm`

-   Draw parameters from (log) normal distribution based on current parameter values and `%CV`

``` r
mod %>% sens_norm(n=10, pars="CL,VC", cv=30)
```

    . # A tibble: 250 × 6
    .       ID  time    .n       CP        CL       VC
    .    <dbl> <dbl> <dbl>    <dbl>     <dbl>    <dbl>
    . 1      1     0     1 0.000000 0.9066935 21.93398
    . 2      1     1     1 2.813610 0.9066935 21.93398
    . 3      1     2     1 3.734743 0.9066935 21.93398
    . 4      1     3     1 3.964286 0.9066935 21.93398
    . 5      1     4     1 3.943835 0.9066935 21.93398
    . 6      1     5     1 3.835664 0.9066935 21.93398
    . 7      1     6     1 3.699298 0.9066935 21.93398
    . 8      1     7     1 3.556471 0.9066935 21.93398
    . 9      1     8     1 3.415018 0.9066935 21.93398
    . 10     1     9     1 3.277672 0.9066935 21.93398
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
  mod %>% 
  ev(amt=100,ii=24, addl=9) %>% update(end=240) %>% Req(CP) %>%
  sens_covset(cov1) 
```

``` r
out
```

    . # A tibble: 24,100 × 5
    .       ID  time       CL       VC       CP
    .    <dbl> <dbl>    <dbl>    <dbl>    <dbl>
    . 1      1     0 1.949184 11.75372 0.000000
    . 2      1     1 1.949184 11.75372 4.888618
    . 3      1     2 1.949184 11.75372 5.939988
    . 4      1     3 1.949184 11.75372 5.693875
    . 5      1     4 1.949184 11.75372 5.067158
    . 6      1     5 1.949184 11.75372 4.382361
    . 7      1     6 1.949184 11.75372 3.745612
    . 8      1     7 1.949184 11.75372 3.185346
    . 9      1     8 1.949184 11.75372 2.703037
    . 10     1     9 1.949184 11.75372 2.291614
    . # ... with 24,090 more rows

``` r
distinct(out,ID,CL,VC)
```

    . # A tibble: 100 × 3
    .       ID       CL       VC
    .    <dbl>    <dbl>    <dbl>
    . 1      1 1.949184 11.75372
    . 2      2 1.146568 38.24549
    . 3      3 1.447339 47.37455
    . 4      4 1.318883 15.58251
    . 5      5 2.683492 34.93966
    . 6      6 3.161431 59.83362
    . 7      7 1.096661 22.29110
    . 8      8 2.085717 65.64706
    . 9      9 2.004095 90.46317
    . 10    10 2.908671 57.62724
    . # ... with 90 more rows
