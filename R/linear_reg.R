#' Wrapper to add the `h2o` engine to the parsnip `linear_reg` model
#' specification
#'
#' @return NULL
#' @export
add_linear_reg_h2o <- function() {

  parsnip::set_model_engine("linear_reg", "regression", "h2o")
  parsnip::set_dependency("linear_reg", "h2o", "h2o")

  parsnip::set_model_arg(
    model = "linear_reg",
    eng = "h2o",
    parsnip = "mixture",
    original = "alpha",
    func = list(pkg = "dials", fun = "mixture"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "linear_reg",
    eng = "h2o",
    parsnip = "penalty",
    original = "lambda",
    func = list(pkg = "dials", fun = "penalty"),
    has_submodel = FALSE
  )
  parsnip::set_fit(
    model = "linear_reg",
    eng = "h2o",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "x", "y", "training_frame"),
      func = c(fun = "h2o_glm_train"),
      defaults = list(
        family = "gaussian",
        model_id = paste("linear_reg", as.integer(runif(1, 0, 1e9)), sep = "_")
        )
    )
  )

  # regression predict
  parsnip::set_pred(
    model = "linear_reg",
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
    model = "linear_reg",
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
}
