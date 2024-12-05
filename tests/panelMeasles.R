# check reproducibility over two randomly chosen seeds
if (file.exists("_options.R")) source("_options.R")
library(panelPomp,quietly=TRUE)


TESTS_PASS <- NULL
test <- function(expr1,expr2,all="TESTS_PASS",env=parent.frame(),...)
  panelPomp:::test(expr1,expr2,all=all,env=env,...)


all_units <- c("Bedwellty", "Leeds", "Lees", "Liverpool", "Nottingham", "Oswestry")

po <- panelMeasles(units = all_units)

test(
  length(po), length(all_units)
)

test(
  wQuotes(
    "Error : in ''panelMeasles'': Parameter names in starting_pparams do not match those in model.\n"
  ),
  panelMeasles(
    units = c('London', 'Leeds'),
    starting_pparams = list(
      shared = c("foo"),
      specific = matrix(0, nrow = 2, ncol = 2, dimnames = list(c('par1', 'par2'), c('unit1', 'unit2')))
    )
  )
)

test(
  is(panelMeasles(units = 'Bristol', interp_method = 'linear'), 'panelPomp'),
)

## check whether all tests passed
all(get(eval(formals(test))$all))
if (!all(get(eval(formals(test))$all))) stop("Not all tests passed!")

