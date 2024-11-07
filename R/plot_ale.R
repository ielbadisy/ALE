#' Plot Accumulated Local Effects (ALE)
#'
#' This function generates a line plot of the ALE values computed for a feature. It allows
#' customization of the plot's title and automatically adjusts the x and y axes labels
#' according to the feature's name. The function uses ggplot2 for plotting.
#'
#' @param ale_data A dataframe containing the results from compute_ale, with columns
#'        'feature' and 'ALE' expected.
#' @param feature_name A string specifying the name of the feature, used to label
#'        the x-axis and to customize the plot title.
#' @param title_suffix A string to be added before the plot title, defaulting to "custom".
#'        This can be used to distinguish plots based on different models or data subsets.
#'
#' @return A ggplot object representing the ALE plot, which can be displayed or further
#'         customized using ggplot2 functions.
#' @examples
#' # Simulate data for example
#' set.seed(123)
#' data <- data.frame(x = runif(100, 0, 1), y = sin(2 * pi * runif(100, 0, 1)) + rnorm(100))
#' model <- lm(y ~ x, data = data)
#' ale_results_x1 <- compute_ale(model, data, "x", 10)
#' plot_ale(ale_results_x1, "x", "Model ALE")
#'
#' @import ggplot2
#' @export
plot_ale <- function(ale_data, feature_name, title_suffix = "custom") {
  # Check if input data is in the expected format
  if (!"feature" %in% names(ale_data) || !"ALE" %in% names(ale_data)) {
    stop("ale_data must contain 'feature' and 'ALE' columns.")
  }

  # Create the ALE plot
  p <- ggplot(ale_data, aes(x = feature, y = ALE)) +
    geom_line(group = 1, color = "blue") +  # You can adjust the color as needed
    labs(title = paste(title_suffix, "ALE plot for", feature_name),
         x = feature_name,
         y = "Accumulated Local Effect (ALE)") +
    theme_minimal()

  return(p)
}
