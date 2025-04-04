
# ALE: Accumulated Local Effects for Interpretable Machine Learning

`ALE` is lighweight R package designed to compute and visualize
[Accumulated Local Effects (ALE)](https://arxiv.org/pdf/1612.08468),
providing interpretability for machine learning models.

## Installation

`ALE` package is not yet on the CRAN, so you can install it directly
from github:

```{r}
#install.packages("devtools")
devtools::install_github("ielbadisy/ALE")
```

    ## Warning in normalizePath(path): path[1]="ielbadisy/ALE": No such file or
    ## directory

    ## Error : Could not copy `ielbadisy/ALE` to `/tmp/RtmpFRltOK/fileb57041d7021f`

## Usage

### Loading the Package

```{r}
library(ALE)
```

### Computing ALE

Use the `compute_ale()` function to calculate ALE for a feature in your
model. Here’s a quick example:

```{r}
library(ALE)

# Simulate some data
set.seed(123)
data <- data.frame(x1 = runif(100), x2 = runif(100))
data$y <- 4 * data$x1 + 3 * data$x2 + rnorm(100)

# Fit a model
model <- lm(y ~ x1 + x2, data = data)

# Define the prediction function explicitly
pred_fun <- stats::predict

# Compute ALE for x1, specifying the prediction function explicitly
ale_x1 <- compute_ale(model, data, "x1", grid_size = 10, pred_fun = pred_fun)
ale_x1
```

    ##       feature        ALE
    ## 1  0.05030702 -1.8320498
    ## 2  0.14967152 -1.4249276
    ## 3  0.24903602 -1.0178054
    ## 4  0.34840052 -0.6106833
    ## 5  0.44776502 -0.2035611
    ## 6  0.54712953  0.2035611
    ## 7  0.64649403  0.6106833
    ## 8  0.74585853  1.0178054
    ## 9  0.84522303  1.4249276
    ## 10 0.94458753  1.8320498

### Plotting ALE

Use the `plot_ale()` function to visualize the ALE values for a feature:

```{r}
# Plot ALE for x1
plot_ale(ale_x1, feature_name = "x1", title_suffix = "Custom Model")
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

### Comparative Analysis with ALEPlot Package

If you wish to compare ALE values computed with this package to those
from the `ALEPlot` package, you can do so with the following steps:

```{r}
# define a custom prediction function with the expected argument names
yhat <- function(X.model, newdata) {
    predict(X.model, newdata = newdata)
}

# now call ALEPlot with the corrected prediction function
ALEPlot_data <- ALEPlot::ALEPlot(data[, c("x1", "x2")], model, pred.fun = yhat, J = 1, K = 10)
```

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## Documentation

Full documentation for `ALE` functions, including additional examples
and parameters, can be found in the package help files:

```{r}
?compute_ale
?plot_ale
```


## Contributing

Contributions are welcome! Please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature or bugfix.
3.  Submit a pull request with a clear description of your changes.

## License

This package is licensed under the [License: GPL
v3](https://img.shields.io/badge/license-GPL--3-blue.svg)\](<https://www.gnu.org/licenses/gpl-3.0>).
