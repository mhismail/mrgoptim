message("\n\nwriting documentation ... \n")

library(methods)
library(devtools)
library(roxygen2)


pkg <- file.path(".")
## message("\nwriting header files for nullmodel and housemodel\n")
r <- file.path(pkg,"R")
src <- file.path(pkg,"src")
inst <- file.path(pkg,"inst")
inc <- file.path(pkg, "inst", "include")
proj <- file.path(pkg, "inst", "project")

document()