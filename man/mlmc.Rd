% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mlmc.R
\name{mlmc}
\alias{mlmc}
\title{Multi-level Monte Carlo estimation}
\usage{
mlmc(
  Lmin,
  Lmax,
  N0,
  eps,
  mlmc_l,
  alpha = NA,
  beta = NA,
  gamma = NA,
  parallel = NA,
  ...
)
}
\arguments{
\item{Lmin}{the minimum level of refinement.  Must be \eqn{\ge 2}.}

\item{Lmax}{the maximum level of refinement.  Must be \eqn{\ge} \code{Lmin}.}

\item{N0}{initial number of samples which are used for the first 3 levels and for any subsequent levels which are automatically added.
Must be \eqn{> 0}.}

\item{eps}{the target accuracy of the estimate (root mean square error).
Must be \eqn{> 0}.}

\item{mlmc_l}{a user supplied function which provides the estimate for level \eqn{l}.
       It must take at least two arguments, the first is the level number to be simulated and the second the number of paths.
       Additional arguments can be taken if desired: all additional \code{...} arguments to this function are forwarded to the user defined \code{mlmc_l} function.

       The user supplied function should return a named list containing one element named \code{sums} and second named \code{cost}, where:
       \describe{
         \item{\code{sums}}{is a vector of length at least two.
                            The first two elements should be \eqn{\left(\sum Y_i, \sum Y_i^2\right)} where \eqn{Y_i} are iid simulations with expectation \eqn{E[P_0]} when \eqn{l=0} and expectation \eqn{E[P_l-P_{l-1}]} when \eqn{l>0}.
                            Note that typically the user supplied level sampler will actually return a vector of length six, also enabling use of the \code{\link[=mlmc.test]{mlmc.test()}} function to perform convergence tests, kurtosis, and telescoping sum checks.
                            See \code{\link[=mlmc.test]{mlmc.test()}} for the definition of these remaining four elements.}
         \item{\code{cost}}{is a scalar with the total cost of the paths simulated.
                            For example, in the financial options samplers included in this package, this is calculated as \eqn{NM^l}, where \eqn{N} is the number of paths requested in the call to the user function \code{mlmc_l}, \eqn{M} is the refinement cost factor (\eqn{M=2} for \code{\link[=mcqmc06_l]{mcqmc06_l()}} and \eqn{M=4} for \code{\link[=opre_l]{opre_l()}}), and \eqn{l} is the level being sampled.}
       }

       See the function (and source code of) \code{\link[=opre_l]{opre_l()}} and \code{\link[=mcqmc06_l]{mcqmc06_l()}} in this package for an example of user supplied level samplers.}

\item{alpha}{the weak error, \eqn{O(2^{-\alpha l})}.
Must be \eqn{> 0} if specified.
If \code{NA} then \code{alpha} will be estimated.}

\item{beta}{the variance, \eqn{O(2^{-\beta l})}.
Must be \eqn{> 0} if specified.
If \code{NA} then \code{beta} will be estimated.}

\item{gamma}{the sample cost, \eqn{O(2^{\gamma l})}.
Must be \eqn{> 0} if specified.
If \code{NA} then \code{gamma} will be estimated.}

\item{parallel}{if an integer is supplied, R will fork \code{parallel} parallel processes and compute each level estimate in parallel.}

\item{...}{additional arguments which are passed on when the user supplied \code{mlmc_l} function is called.}
}
\value{
A named list containing: \describe{
  \item{\code{P}}{The MLMC estimate;}
  \item{\code{Nl}}{A vector of the number of samples performed on each level;}
  \item{\code{Cl}}{Per sample cost at each level.}
}
}
\description{
This function is the Multi-level Monte Carlo driver which will sample from the levels of user specified function.
}
\details{
The Multilevel Monte Carlo Method method originated in the works Giles (2008) and Heinrich (1998).

Consider a sequence \eqn{P_0, P_1, \ldots}, which approximates \eqn{P_L} with increasing accuracy, but also increasing cost, we have the simple identity
\deqn{E[P_L] = E[P_0] + \sum_{l=1}^L E[P_l-P_{l-1}],}
and therefore we can use the following unbiased estimator for \eqn{E[P_L]},
\deqn{N_0^{-1} \sum_{n=1}^{N_0} P_0^{(0,n)} + \sum_{l=1}^L \left\{ N_l^{-1} \sum_{n=1}^{N_l} \left(P_l^{(l,n)} - P_{l-1}^{(l,n)}\right) \right\}}
where \eqn{N_l} samples are produced at level \eqn{l}.
The inclusion of the level \eqn{l} in the superscript \eqn{(l,n)} indicates that the samples used at each level of correction are independent.

Set \eqn{C_0}, and \eqn{V_0} to be the cost and variance of one sample of \eqn{P_0}, and \eqn{C_l, V_l} to be the cost and variance of one sample of \eqn{P_l - P_{l-1}}, then the overall cost and variance of the multilevel estimator is \eqn{\sum_{l=0}^L N_l C_l} and \eqn{\sum_{l=0}^L N_l^{-1} V_l}, respectively.

The idea behind the method, is that provided that the product \eqn{V_l C_l} decreases with \eqn{l}, i.e. the cost increases with level slower than the variance decreases, then one can achieve significant computational savings, which can be formalised as in Theorem 1 of Giles (2015).

For further information on multilevel Monte Carlo methods, see the webpage \url{https://people.maths.ox.ac.uk/gilesm/mlmc_community.html} which lists the research groups working in the area, and their main publications.

This function is based on GPL-2 'Matlab' code by Mike Giles.
}
\examples{
mlmc(2, 6, 1000, 0.01, opre_l, option = 1)

mlmc(2, 10, 1000, 0.01, mcqmc06_l, option = 1)

}
\references{
Giles, M.B. (2008) 'Multilevel Monte Carlo Path Simulation', \emph{Operations Research}, 56(3), pp. 607–617. Available at: \doi{10.1287/opre.1070.0496}.

Giles, M.B. (2015) 'Multilevel Monte Carlo methods', \emph{Acta Numerica}, 24, pp. 259–328. Available at: \doi{10.1017/S096249291500001X}.

Heinrich, S. (1998) 'Monte Carlo Complexity of Global Solution of Integral Equations', \emph{Journal of Complexity}, 14(2), pp. 151–175. Available at: \doi{10.1006/jcom.1998.0471}.
}
\author{
Louis Aslett <louis.aslett@durham.ac.uk>

Mike Giles <Mike.Giles@maths.ox.ac.uk>

Tigran Nagapetyan <nagapetyan@stats.ox.ac.uk>
}
