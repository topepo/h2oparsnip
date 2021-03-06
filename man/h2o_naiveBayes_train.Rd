% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/naive_Bayes.R
\name{h2o_naiveBayes_train}
\alias{h2o_naiveBayes_train}
\title{Wrapper for training a h2o.naiveBayes model as part of a discrim `naive_Bayes`
h2o engine}
\usage{
h2o_naiveBayes_train(formula, data, model_id, laplace = 0, ...)
}
\arguments{
\item{formula}{formula}

\item{data}{data.frame of training data}

\item{model_id}{A randomly assigned identifier for the model. Used to refer
to the model within the h2o cluster.}

\item{laplace}{numeric, the Laplace smoothing parameter, must be >= 0.}

\item{...}{other arguments not currently used}
}
\value{
evaluated h2o model call
}
\description{
Wrapper for training a h2o.naiveBayes model as part of a discrim `naive_Bayes`
h2o engine
}
