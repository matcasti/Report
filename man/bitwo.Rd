% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bitwo.R
\name{bitwo}
\alias{bitwo}
\title{Independent two samples testing}
\usage{
bitwo(
  data,
  variable,
  by,
  type = "auto",
  var.equal = FALSE,
  trim = 0.1,
  nboot = 100,
  markdown = TRUE,
  ...
)
}
\arguments{
\item{data}{Your dataset in long format, can have some missing values.}

\item{variable}{Response variable, numeric.}

\item{by}{Grouping variable, a factor. It can have more than two levels.}

\item{type}{Whether you want to manually specify a parametric test (type = 'p'), a non-parametric test (type = 'np') or a robust test (type = 'r').}

\item{var.equal}{If \code{TRUE}, then Welch correction is applied to the degrees of freedom, only when \code{type = 'p'}.}

\item{trim}{Trim level for the mean (available only for robust test).}

\item{nboot}{Number of bootstrap samples used for robust methods.}

\item{markdown}{Whether you want the \verb{$report} output formated for inline RMarkdown or as plain text.}

\item{...}{Currently not used.}
}
\value{
A list of length 2 with \verb{$report} of statistical test and \verb{$method} used.
}
\description{
This is function let you perform automated inferential testing based on certain assumptions, some of which are tested automatically, then the propper test is perform, giving you an APA formated output with your statistical results.
}
\keyword{bitwo}
