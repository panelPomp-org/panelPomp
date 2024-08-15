if (file.exists("_options.R")) source("_options.R")
library(panelPomp,quietly=TRUE)
TESTS_PASS <- NULL

test <- function(expr1,expr2,all="TESTS_PASS",env=parent.frame(),...)
  panelPomp:::test(expr1,expr2,all=all,env=env,...)

pg <- panelGompertz(U=3,N=10)
sh <- c(shared.1=1,shared.2=2)
u <- 5 # at least 1
sp <- matrix(
  as.numeric(paste0(rep(seq(3,u+2),each=2),rep(c(".1",".2"),times=u))),
  nrow=2,
  dimnames=list(param = c("spec.1","spec.2"),unit = c(paste0("unit.",1:u)))
)

out_null_sp <- toParamList(
  toParamVec(
    list(shared=sh,specific=array(
      numeric(0),dim=c(0,ncol(sp)),dimnames=list(NULL,colnames(sp)))
    )
  )
)

## recovec pParams (shared parameters only)
test(all(dim(out_null_sp$specific) == c(0, 0)))
test(out_null_sp$shared, sh)

## recovec pParams (specific parameters only)
test(list(shared=numeric(0),specific=sp),
  toParamList(toParamVec(list(shared=numeric(0),specific=sp))))
## recovec pParams (both)
test(list(shared=sh,specific=sp),
     toParamList(toParamVec(list(shared=sh,specific=sp))))

## tolspPs and toMatrixPparams work (shared parameters only)
list(shared=sh,specific=array(numeric(0),dim=c(0,ncol(sp)),
                              dimnames=list(NULL,colnames(sp)))) -> lspPs
matrixPparams <- panelPomp:::toMatrixPparams(lspPs)
vector.position.in.lspPs <- which(sapply(lspPs,is.vector))
names.in.vector <- names(lspPs[vector.position.in.lspPs]$shared)
vector.name.in.lspPs <- names(lspPs)[vector.position.in.lspPs]
matrix.name.in.lspPs <- names(lspPs)[ifelse(vector.position.in.lspPs==1,2,1)]
res <- panelPomp:::toListPparams(
  matrixPparams=matrixPparams,names.in.vector=names.in.vector,
  vector.position.in.listPparams=vector.position.in.lspPs,
  vector.name.in.listPparams=vector.name.in.lspPs,
  matrix.name.in.listPparams=matrix.name.in.lspPs)
test(res,lspPs)

## tolistPparams and toMatrixPparams work (specific parameters only)
listPparams <-list(shared=numeric(0),specific=sp)

matrixPparams <- panelPomp:::toMatrixPparams(listPparams)
vector.position.in.listPparams <- which(sapply(listPparams,is.vector))
names.in.vector <- names(listPparams[vector.position.in.listPparams]$shared)
vector.name.in.listPparams <- names(listPparams)[vector.position.in.listPparams]
matrix.name.in.listPparams <- names(listPparams)[ifelse(vector.position.in.listPparams == 1,2,1)]

res <- panelPomp:::toListPparams(
  matrixPparams=matrixPparams,
  names.in.vector=names.in.vector,
  vector.position.in.listPparams=vector.position.in.listPparams,
  vector.name.in.listPparams=vector.name.in.listPparams,
  matrix.name.in.listPparams=matrix.name.in.listPparams
)
dimnames(res$specific) <- list(param=rownames(res$specific), unit=colnames(res$specific))

test(res,listPparams)

## tolistPparams and toMatrixPparams work (both)
listPparams <- list(shared=sh,specific=sp)

matrixPparams <- panelPomp:::toMatrixPparams(listPparams)
vector.position.in.listPparams <- which(sapply(listPparams,is.vector))
names.in.vector <- names(listPparams[vector.position.in.listPparams]$shared)
vector.name.in.listPparams <- names(listPparams)[vector.position.in.listPparams]
matrix.name.in.listPparams <- names(listPparams)[ifelse(vector.position.in.listPparams == 1,2,1)]

res <- panelPomp:::toListPparams(
  matrixPparams=matrixPparams,
  names.in.vector=names.in.vector,
  vector.position.in.listPparams=vector.position.in.listPparams,
  vector.name.in.listPparams=vector.name.in.listPparams,
  matrix.name.in.listPparams=matrix.name.in.listPparams
)
dimnames(res$specific) <- list(param=rownames(res$specific), unit=colnames(res$specific))


ep <- "Error : in ''toParamVec'': "
## test checks for missing arguments in panelPomp function
test(
  wQuotes(ep,"input must be a list.\n"),
  toParamVec(c(1, 2, 3))
)

test(
  wQuotes(ep, 'input must have shared or specific components.\n'),
  toParamVec(list(a=c(1, 2, 3)))
)

test(res,listPparams)

## check whether all tests passed
all(get(eval(formals(test))$all))
if (!all(get(eval(formals(test))$all))) stop("Not all tests passed!")
