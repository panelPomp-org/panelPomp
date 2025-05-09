if (file.exists("_options.R")) source("_options.R")
library(panelPomp,quietly=TRUE)

TESTS_PASS <- NULL
test <- function(expr1,expr2,all="TESTS_PASS",env=parent.frame(),...)
  panelPomp:::test(expr1,expr2,all=all,env=env,...)

ep <- wQuotes("Error : (converted from warning) in ''plot'': ")

old_o <- options(digits=3)
options(warn = 2)
png(file.path(tempdir(),"plot-%02d.png"),res=100)
ppo <- panelPomp:::panelRandomWalk(N=5,U=2)
plot(ppo)
dev.off()

options(old_o)

test(
  wQuotes(ep,"Requested units: c(foo) are not part of the object ''x''.\n"),
  plot(ppo, units = c("rw1", "foo"))
)

test(
  wQuotes(ep, "Requested units are not part of the object ''x''. All units objects will be plotted.\n"),
  plot(ppo, units = c("foo", "bar"))
)

## check whether all tests passed
all(get(eval(formals(test))$all))
if (!all(get(eval(formals(test))$all))) stop("Not all tests passed!")
