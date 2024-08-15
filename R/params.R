## functions to manipulate params

#' @include panelPomp_methods.R
NULL

#' @title Manipulating \code{panelPomp} object parameter formats
#' @description These facilitate keeping a record of evaluated log likelihoods.
#' @param pParams A list with both shared (vector) and unit-specific (matrix) parameters.
#' @name params
NULL

#' @rdname params
#' @author Carles \Breto
#' @return
#' \code{toParamVec()} returns model parameters in vector form. This function
#' is the inverse of \link{toParamList}
#' @examples
#' prw <- panelRandomWalk()
#' toParamVec(coef(prw, format = 'list'))
#' @export
toParamVec <- function(pParams) {

  ep <- wQuotes("in ''toParamVec'': ")
  if (!is.list(pParams)) stop(ep, 'input must be a list.', call. = FALSE)
  if (is.null(pParams$shared) && is.null(pParams$specific)) stop(ep, 'input must have shared or specific components.', call. = FALSE)

  # Create a new list, removing unused components.
  value <- list(shared=pParams$shared, specific = pParams$specific)

  c(
    value$shared,
    setNames(
      as.numeric(value$specific),
      outer(rownames(value$specific),colnames(value$specific),sprintf,fmt="%s[%s]")
    )
  )
}

## Go to list-form pparams from matrix specification
# @author Carles \Breto
toListPparams <- function(
  matrixPparams,
  names.in.vector,
  vector.position.in.listPparams,
  vector.name.in.listPparams,
  matrix.name.in.listPparams
) {
  output <- as.vector(c(NA,NA), mode = "list")
  # fill vector in
  output[[vector.position.in.listPparams]] <- matrixPparams[names.in.vector,1]
  # fill matrix in
  name.logicals.for.matrix <- !rownames(matrixPparams) %in% names.in.vector
  output[[ifelse(vector.position.in.listPparams==1,2,1)]] <-
    if(any(name.logicals.for.matrix)) {
      matrixPparams[name.logicals.for.matrix, , drop = FALSE]} else {
        # fill empty matrix in
        array(
          data = numeric(0),
          dim = c(0, dim(matrixPparams)[2]),
          dimnames = list(NULL, dimnames(matrixPparams)[[2]])
        )
      }
  names(output)[vector.position.in.listPparams] <- vector.name.in.listPparams
  names(output)[ifelse(vector.position.in.listPparams==1,2,1)] <- matrix.name.in.listPparams
  output
}

## Go to matrix-form pparams from list specification
#' @rdname params
#' @param listPparams PanelPomp parameters in list format
# @author Carles \Breto
#' @return
#' \code{toMatrixPparams()} returns an object of class \code{matrix} with the
#' model parameters in matrix form.
#' @examples
#' toMatrixPparams(coef(prw, format = 'list'))
#' @export
toMatrixPparams <- function(listPparams) {
  common.params <- listPparams[[which(sapply(listPparams, is.vector))]]
  specific.params <- listPparams[[which(sapply(listPparams, is.matrix))]]

  U <- dim(specific.params)[2]
  matrixPparams <- rbind(
    matrix(
      rep(x = common.params, times = U),
      ncol = U,
      dimnames = list(names(common.params), NULL)
    ),
  specific.params)
  matrixPparams
}
