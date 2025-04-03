if (file.exists("_options.R")) source("_options.R")
library(panelPomp,quietly=TRUE)

TESTS_PASS <- NULL
test <- function(expr1,expr2,all="TESTS_PASS",env=parent.frame(),...)
  panelPomp:::test(expr1,expr2,all=all,env=env,...)

set.seed(123)

U <- 100
Np <- 500
specific_p <- 3
spnames <- paste0("var", 1:specific_p)
unit_names <- paste0('U', 1:U)

# Initializing Array
dats <- rnorm(n = specific_p * Np * U)

pparamArray1 <- array(
  data = dats,
  dim = c(length(spnames), Np, U),
  dimnames = list(
    variable = spnames,
    rep = NULL,
    unit = unit_names
  )
)

# Ensure deep copy, not referencing same memory as above.
pparamArray2 <- array(
  data = dats,
  dim = c(length(spnames), Np, U),
  dimnames = list(
    variable = spnames,
    rep = NULL,
    unit = unit_names
  )
)

test(all.equal(pparamArray1, pparamArray2))

indices <- sample(1:Np, replace = TRUE)
unit <- 2L

pparamArray1[spnames, , -unit] <- pparamArray1[spnames, indices, -unit, drop = FALSE]
pparamArray2 <- panelPomp:::.modifyOther(pparamArray2, spnames, indices, unit)

test(all.equal(pparamArray1, pparamArray2))

M <- matrix(rnorm(length(spnames) * Np), nrow = length(spnames))

pparamArray1[spnames, , unit] <- M
pparamArray2 <- panelPomp:::.modifySelf(pparamArray2, spnames, M, unit)

test(all.equal(pparamArray1, pparamArray2))

## check whether all tests passed
all(get(eval(formals(test))$all))
if (!all(get(eval(formals(test))$all))) stop("Not all tests passed!")
