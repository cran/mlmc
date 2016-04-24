// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// mcqmc06_l
NumericVector mcqmc06_l(int l, int N, int option);
RcppExport SEXP mlmc_mcqmc06_l(SEXP lSEXP, SEXP NSEXP, SEXP optionSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< int >::type l(lSEXP);
    Rcpp::traits::input_parameter< int >::type N(NSEXP);
    Rcpp::traits::input_parameter< int >::type option(optionSEXP);
    __result = Rcpp::wrap(mcqmc06_l(l, N, option));
    return __result;
END_RCPP
}
