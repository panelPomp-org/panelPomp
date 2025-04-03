#include <R.h>
#include <Rinternals.h>

SEXP updateOther(SEXP x, SEXP spindices, SEXP indices, SEXP unit, SEXP dims) {
  // Convert inputs to C types
  double *x_ptr = REAL(x);
  int *spindices_ptr = INTEGER(spindices);
  int *indices_ptr = INTEGER(indices);
  int unit_val = INTEGER(unit)[0] - 1; // Convert to 0-based index
  int *dims_ptr = INTEGER(dims);

  int p = dims_ptr[0]; // Number of rows
  int N = dims_ptr[1]; // Number of cols
  int U = dims_ptr[2]; // Number of layers

  double tmp_buffer[N];

  for (int i = 0; i < p; ++i) {
    int sp = spindices_ptr[i] - 1; // Adjust for 0-based index

    for (int u = 0; u < U; ++u) {
      if (u == unit_val) continue; // Skip unit

      for (int n = 0; n < N; ++n) {
        int idx = sp + (indices_ptr[n] - 1) * p + u * p * N;
        tmp_buffer[n] = x_ptr[idx];
      }

      for (int n = 0; n < N; ++n) {
        // int from_index = sp + (indices_ptr[n] - 1) * p + unit_val * p * N;
        int to_index   = sp + n * p + u * p * N;
        x_ptr[to_index] = tmp_buffer[n];
      }
    }
  }

  return x; // Return void function in R terms
}

SEXP updateSelf(SEXP x, SEXP spindices, SEXP M, SEXP unit, SEXP dims) {
  // Convert inputs to C types
  double *x_ptr = REAL(x);
  int *spindices_ptr = INTEGER(spindices);
  double *M_ptr = REAL(M);
  int unit_val = INTEGER(unit)[0] - 1; // Convert to 0-based index
  int *dims_ptr = INTEGER(dims);

  int p = dims_ptr[0]; // Number of rows
  int N = dims_ptr[1]; // Number of cols

  // Iterate over specified spnames
  for (int i = 0; i < p; ++i) {
    int sp = spindices_ptr[i] - 1; // Adjust for 0-based index

    // Applying matrix M to the specified unit layer for given spnames
    for (int n = 0; n < N; ++n) {
      int to_idx = sp + n * p + unit_val * p * N;   // Index in pparamArray
      int from_idx = sp + n * p; // Index in M
      x_ptr[to_idx] = M_ptr[from_idx];
    }
  }

  return x;
}
