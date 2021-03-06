#' Wrapper to add the `h2o` engine to the parsnip `rand_forest` model
#' specification
#'
#' @return NULL
#' @export
add_rand_forest_h2o <- function() {

  parsnip::set_model_engine("rand_forest", "classification", "h2o")
  parsnip::set_model_engine("rand_forest", "regression", "h2o")
  parsnip::set_dependency("rand_forest", "h2o", "h2o")

  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "h2o",
    parsnip = "trees",
    original = "ntrees",
    func = list(pkg = "dials", fun = "trees"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "h2o",
    parsnip = "min_n",
    original = "min_rows",
    func = list(pkg = "dials", fun = "min_n"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "h2o",
    parsnip = "mtry",
    original = "mtries",
    func = list(pkg = "dials", fun = "mtry"),
    has_submodel = FALSE
  )
  parsnip::set_fit(
    model = "rand_forest",
    eng = "h2o",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "x", "y", "training_frame"),
      func = c(fun = "h2o_rf_train"),
      defaults = list(
        model_id = paste("rand_forest", as.integer(runif(1, 0, 1e9)), sep = "_")
      )
    )
  )
  parsnip::set_fit(
    model = "rand_forest",
    eng = "h2o",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "x", "y", "training_frame"),
      func = c(fun = "h2o_rf_train"),
      defaults = list(
        model_id = paste("rand_forest", as.integer(runif(1, 0, 1e9)), sep = "_")
      )
    )
  )

  # regression predict
  parsnip::set_pred(
    model = "rand_forest",
    eng = "h2o",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = function(x, object) h2o::as.h2o(x),
      post = function(x, object) as.data.frame(x)$predict,
      func = c(pkg = "h2o", fun = "h2o.predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )
  parsnip::set_pred(
    model = "rand_forest",
    eng = "h2o",
    mode = "regression",
    type = "raw",
    value = list(
      pre = function(x, object) h2o::as.h2o(x),
      post = function(x, object) as.data.frame(x),
      func = c(pkg = "h2o", fun = "h2o.predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )

  # classification predict
  parsnip::set_pred(
    model = "rand_forest",
    eng = "h2o",
    mode = "classification",
    type = "class",
    value = list(
      pre = function(x, object) h2o::as.h2o(x),
      post = function(x, object) as.data.frame(x)$predict,
      func = c(pkg = "h2o", fun = "h2o.predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )
  parsnip::set_pred(
    model = "rand_forest",
    eng = "h2o",
    mode = "classification",
    type = "prob",
    value = list(
      pre = function(x, object) h2o::as.h2o(x),
      post = function(x, object) as.data.frame(x[, 2:ncol(x)]),
      func = c(pkg = "h2o", fun = "h2o.predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )
  parsnip::set_pred(
    model = "rand_forest",
    eng = "h2o",
    mode = "classification",
    type = "raw",
    value = list(
      pre = function(x, object) h2o::as.h2o(x),
      post = function(x, object) as.data.frame(x),
      func = c(pkg = "h2o", fun = "h2o.predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )
}

#' Wrapper for training a h2o.randomForest model as part of a parsnip
#' `rand_forest` h2o engine
#'
#' @param formula formula
#' @param data data.frame of training data
#' @param model_id A randomly assigned identifier for the model. Used to refer
#'   to the model within the h2o cluster.
#' @param ntrees integer, the number of trees to build (default = 50)
#' @param min_rows integer, the minimum number of observations for a leaf
#'   (default = 10)
#' @param mtries integer, the number of columns to randomly select at each
#' level. Default of -1 is sqrt(p) for classification and (p/3) for regression.
#' @param ... other arguments not currently used
#'
#' @return evaluated h2o model call
#' @export
h2o_rf_train <-
  function(formula,
           data,
           model_id,
           ntrees = 50,
           min_rows = 10,
           mtries = -1,
           ...) {

    others <- list(...)

    # convert to H2OFrame, get response and predictor names
    pre <- preprocess_training(formula, data)

    # define arguments
    args <- list(
      model_id = model_id,
      x = pre$X,
      y = pre$y,
      training_frame = pre$data,
      ntrees = ntrees,
      min_rows = min_rows,
      mtries = mtries
    )

    make_h2o_call("h2o.randomForest", args, others)
  }
