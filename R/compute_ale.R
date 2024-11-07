#' Compute Accumulated Local Effects (ALE) for a Single Feature
#'
#' This function calculates and returns the Accumulated Local Effects (ALE) for a given feature
#' in a predictive model. ALE quantifies the effect of a feature on the predictions of a model,
#' averaged over the range of other features. It handles both categorical and continuous features.
#'
#' @param model The predictive model object from which predictions are derived.
#' @param data A data frame containing the data used in the model.
#' @param feature A string specifying the column name of the feature for which the ALE is to be computed.
#' @param grid_size An integer specifying the number of intervals into which the feature range is divided for ALE computation, applicable only to continuous features.
#' @param pred_fun A prediction function that takes the model object and a new data frame, and returns a vector of predictions.
#'                 Default is `predict`. The prediction function should return numeric output and must be compatible with the type of model provided.
#'
#' @return A data frame with two columns: `feature` and `ALE`. For continuous features, `feature` represents the midpoints of the intervals used in the computation.
#'         For categorical features, `feature` represents the levels of the feature.
#' @examples
#' # Assuming 'model' is a previously trained model on 'data'
#' set.seed(123)
#' data <- data.frame(x1 = runif(100), x2 = runif(100))
#' data$y <- with(data, 2 * x1 + 3 * x2 + rnorm(100))
#' model <- lm(y ~ x1 + x2, data = data)
#'
#' # Compute ALE for 'x1'
#' ale_results <- compute_ale(model, data, "x1", grid_size = 10)
#' print(ale_results)
#'
#' @export
#' @importFrom stats predict
compute_ale <- function(model, data, feature, grid_size = 100, pred_fun = predict) {
  if (is.factor(data[[feature]])) {
    levels <- levels(data[[feature]])
    ale_values <- numeric(length(levels))
    for (i in 1:length(levels)) {
      data_copy <- data
      data_copy[[feature]] <- factor(levels[i], levels = levels)
      ale_values[i] <- mean(pred_fun(model, newdata = data_copy))
    }
    ale_values <- ale_values - mean(ale_values)
    return(data.frame(feature = levels, ALE = ale_values))
  } else {
    feature_vals <- data[[feature]]
    min_val <- min(feature_vals)
    max_val <- max(feature_vals)
    breaks <- seq(min_val, max_val, length.out = grid_size + 1)
    ale_values <- numeric(grid_size)

    for (i in 1:grid_size) {
      data_low <- data[data[[feature]] > breaks[i] & data[[feature]] <= breaks[i + 1], ]
      if (nrow(data_low) > 0) {
        data_low[[feature]] <- breaks[i]
        data_high <- data_low
        data_high[[feature]] <- breaks[i + 1]

        pred_low <- pred_fun(model, newdata = data_low)
        pred_high <- pred_fun(model, newdata = data_high)
        ale_values[i] <- mean(pred_high - pred_low)
      }
    }

    ale_values <- cumsum(ale_values) - mean(cumsum(ale_values))
    return(data.frame(feature = (breaks[-1] + breaks[-length(breaks)]) / 2, ALE = ale_values))
  }
}
