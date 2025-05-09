## generic functions

#' @title Extract units of a panel model
#' @description \code{unit_objects()} is a generic function that extracts a list
#' of objects corresponding to units of panel objects returned by panel modeling
#' functions.
#' @param object an object for which extraction of panel units is meaningful.
#' @param ... additional arguments.
#' @details This is a generic function: methods can be defined for it.
#' @return Units extracted from the panel model \code{object}.
#'
#' \unitobjectsReturn
#' @example examples/prw.R
#' @example examples/unitobjects.R
#' @keywords internal
#' @seealso \link{panelPomp_methods}
#' @author Carles \Breto
#' @export
setGeneric(name = "unit_objects",
           def = function(object, ...) standardGeneric("unit_objects"))

#' @name unitLogLik
#' @title Extract log likelihood of units of panel models
#' @description \code{unitLogLik()} is a generic function that extracts the log
#' likelihood for each unit of panel objects returned by panel modeling functions.
#' While the \code{numeric} value with the log likelihood for the entire panel
#' is useful and possible via S4 methods \code{logLik()}, the contributions to it
#' by panel units can be implemented via \code{unitLogLik()}.
#' @param object an object for which log likelihood values for units can be extracted.
#' @param ... additional arguments.
#' @details This is a generic function: methods can be defined for it.
#' @return Log likelihood extracted for each unit of the panel model \code{object}.
#'
#' \unitLogLikReturn
#' @example examples/pfrw.R
#' @example examples/unitLogLik.R
#' @keywords internal
#' @seealso \link{pfilter}
#' @author Carles \Breto
#' @export
setGeneric(name = "unitLogLik",
           def = function(object, ...) standardGeneric("unitLogLik"))

#' Extract unit-specific parameters from a panelPomp object
#'
#' This function is used to extract the unit-specific parameters from a
#' panel pomp object.
#'
#' @param object an object that contains unit-specific parameters
#' @param format character representing how the parameters should be returned
#' @param ... additional arguments.
#'
#' @return a matrix or vector containing the unit-specific parameters
#'
#' @example examples/prw.R
#' @example examples/get_specific.R
#' @keywords internal
#' @seealso \link{panelPomp_methods}
#' @author Jesse Wheeler
#' @export
setGeneric(name = "specific",
           def = function(object, ..., format = c('matrix', 'vector')) standardGeneric('specific')
)

#' Set unit-specific parameters of a panelPomp object
#'
#' This function is used to set the unit-specific parameters of a
#' panel pomp object.
#'
#' @param object an object that contains unit-specific parameters.
#' @param value a numeric matrix with column names matching the names of the
#'    `unit_objects` slot, and row names matching the names of the unit-specific
#'    parameters. Alternatively, this can be a named vector following the naming
#'    convention `<parameter>[<unit_name>]`.
#'
#' @example examples/set_specific.R
#' @keywords internal
#' @seealso \link{panelPomp_methods}
#' @author Jesse Wheeler
#' @export
setGeneric(name = "specific<-",
           def = function(object, value) standardGeneric('specific<-')
)

#' Extract shared parameters from a panelPomp object
#'
#' This function is used to extract the shared parameters from a panelPomp
#' object.
#'
#' @param object an object that contains shared parameters.
#' @param ... additional arguments.
#'
#' @return vector containing the shared parameters
#'
#' @example examples/prw.R
#' @example examples/get_shared.R
#' @keywords internal
#' @seealso \link{panelPomp_methods}
#' @author Jesse Wheeler
#' @export
setGeneric(name = "shared",
           def = function(object, ...) standardGeneric('shared')
)

#' Set shared parameters of a panelPomp object
#'
#' This function is used to set the shared parameters of a panel pomp object.
#'
#' @param object an object that contains shared parameters.
#' @param value a named numeric vector containing the desired values of the
#'    shared parameter vector.
#'
#' @example examples/prw.R
#' @example examples/set_shared.R
#' @keywords internal
#' @seealso \link{panelPomp_methods}
#' @author Jesse Wheeler
#' @export
setGeneric(name = "shared<-",
           def = function(object, value) standardGeneric('shared<-')
)

