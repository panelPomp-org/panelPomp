% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panelPomp_methods.R
\docType{methods}
\name{panelPomp_methods}
\alias{panelPomp_methods}
\alias{coef,panelPomp-method}
\alias{coef<-,panelPomp-method}
\alias{length,panelPomp-method}
\alias{names,panelPomp-method}
\alias{toParamList}
\alias{print,panelPomp-method}
\alias{show,panelPomp-method}
\alias{unit_objects,panelPomp-method}
\alias{window,panelPomp-method}
\alias{[,panelPomp-method}
\alias{[[,panelPomp-method}
\alias{specific,panelPomp-method}
\alias{specific<-,panelPomp-method}
\alias{shared,panelPomp-method}
\alias{shared<-,panelPomp-method}
\title{Manipulating \code{panelPomp} objects}
\usage{
\S4method{coef}{panelPomp}(object, format = c("vector", "list"))

\S4method{coef}{panelPomp}(object, ...) <- value

\S4method{length}{panelPomp}(x)

\S4method{names}{panelPomp}(x)

toParamList(value)

\S4method{print}{panelPomp}(x, ...)

\S4method{show}{panelPomp}(object)

\S4method{unit_objects}{panelPomp}(object)

\S4method{window}{panelPomp}(x, start, end)

\S4method{[}{panelPomp}(x, i)

\S4method{[[}{panelPomp}(x, i)

\S4method{specific}{panelPomp}(object, ..., format = c("matrix", "vector"))

\S4method{specific}{panelPomp}(object) <- value

\S4method{shared}{panelPomp}(object)

\S4method{shared}{panelPomp}(object) <- value
}
\arguments{
\item{object, x}{An object of class \code{panelPomp} or inheriting class
\code{panelPomp}.}

\item{format}{the format (data type) of the return value.}

\item{...}{....}

\item{value}{value to be assigned.}

\item{start, end}{position in original \code{times(pomp)} at which to start.}

\item{i}{unit index (indices) or name (names).}
}
\value{
\code{coef()} returns a \code{numeric} vector.

\code{length()} returns an \code{integer}.

\code{names()} returns a \code{character} vector.

\code{toParamList()} returns a \code{list} with the model parameters in list form.

\unitobjectsReturn

\code{window()} returns a \code{panelPomp} object with adjusted times.

\code{`[`} returns a \code{panelPomp} object.

\code{`[[`} returns a \code{pomp} object.

\code{specific()} returns unit-specific parameters as a numeric matrix or
vector

\code{shared()} returns shared parameters from a panelPomp object
}
\description{
Tools for manipulating \code{panelPomp} objects.
}
\section{Methods}{

\describe{
\item{coef}{Extracts coefficients of \code{panelPomp} objects.}
\item{coef<-}{Assign coefficients to \code{panelPomp} objects.}
\item{length}{Count the number of units in \code{panelPomp} objects.}
\item{names}{Get the unit names of \code{panelPomp} objects.}
\item{toParamList}{Converts panel coefficients from vector form to list form.}
\item{window}{Subset \code{panelPomp} objects by changing start time and
end time.}
\item{\code{[]}}{Take a subset of units.}
\item{\code{[[]]}}{Select the pomp object for a single unit.}
\item{specific}{Extracts the \code{specific} coefficients.}
\item{specific<-}{Assigns the \code{specific} coefficients.}
\item{shared}{Extracts the \code{shared} coefficients.}
\item{shared<-}{Assigns the \code{shared} coefficients.}
}
}

\examples{
## access and manipulate model parameters and other features
prw <- panelRandomWalk()
coef(prw)
# replace coefficients
coef(prw) <- c(sigmaX=2,coef(prw)[-1])
coef(prw)
length(prw)
names(prw)
# convert vector-form parameters to list-form parameters
toParamList(coef(prw))
## summaries of objects
print(prw)
show(prw)
## access underlying pomp objects
unit_objects(prw)
## select windows of time
window(prw,start=2,end=4)
## subsetting panelPomp objects
prw[1] # panelPomp of 1 unit (first unit of prw)
prw[[2]] # pomp object corresponding to unit 2 of prw
# access and manipulate model parameters and other features
specific(prw)
# replace unit-specific coefficients
specific(prw) <- c("sigmaX[rw1]"=2)
specific(prw)
# access and manipulate model parameters and other features
shared(prw)
# replace unit-specific coefficients
shared(prw) <- c('sigmaY'=2)
shared(prw)
}
\seealso{
Other panelPomp methods: 
\code{\link{as}()}
}
\author{
Carles \Breto, Aaron A. King, Edward L. Ionides, Jesse Wheeler
}
\concept{panelPomp methods}
