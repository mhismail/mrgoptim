# Copyright (C) 2017  Metrum Research Group, LLC
#
# This file is part of mrgsolvetk.
#
# mrgsolvetk is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# mrgsolvetk is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with mrgsolvetk.  If not, see <http://www.gnu.org/licenses/>.

library(testthat)
library(mrgsolvetk)
library(dplyr)
Sys.setenv(R_TESTS="")
options("mrgsolve_mread_quiet"=TRUE)


context("Starter test")


test_that("Sensitivity analysis - uniform", {
  mod <- mrgsolve:::house()
  out <- sens_unif(mod, lower=0.5,upper=1, pars="CL")
  expect_is(out, "data.frame")  
  
})


