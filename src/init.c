#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

extern SEXP updateOther(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP updateSelf(SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"updateOther", (DL_FUNC) &updateOther, 5},
  {"updateSelf", (DL_FUNC) &updateSelf, 5},
  {NULL, NULL, 0}
};

void R_init_panelPomp(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, TRUE);
}
