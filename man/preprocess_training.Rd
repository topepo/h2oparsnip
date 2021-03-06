% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_h2oframe.R
\name{preprocess_training}
\alias{preprocess_training}
\title{Preprocess training data for use with h2o models}
\usage{
preprocess_training(formula, data)
}
\arguments{
\item{formula}{formula object}

\item{data}{data.frame of predictors and response variable}
}
\value{
list(data = H2OFrame, X = predictor names, y = response name)
}
\description{
Preprocess training data for use with h2o models
}
