#' Impute the spatial lag of neighbors
#'
#' The `st_impute_lag` function computes the spatial lag for a given variable by
#' replacing missing (`NA`) values using a user-specified function applied to
#' neighbors' values (default function is mean). The imputation is done selectively for `NA` values only,
#' retaining non-`NA` entries of the input vector `x`.
#'
#' @param x A numeric vector of spatial data with potential `NA` values to be imputed.
#' @param nb A neighbor list object indicating the spatial relationships
#'    between observations. Typically, this could be generated by
#'    `sfdep::st_contiguity()`, `sfdep::st_knn()` or other spatial-dependency identifying methods.
#' @param FUN A function to be applied to compute the spatial lag, e.g., `mean`,
#'    `median`, etc. Default is `mean`.
#' @param na_okay Logical, defaulting to `FALSE`. If `TRUE`, allows the presence
#'    of `NA` values in `x` during the imputation. If `FALSE`, any `NA` value
#'    encountered will generate an error.
#' @param allow_zero A logical value or `NULL`. If `TRUE`, assigns zero as
#'    lagged value to zones without neighbors. If `FALSE`, zones without
#'    neighbors will generate an error. Default is `NULL`.
#' @param ... Additional parameters passed to underlying functions.
#'
#' @details
#' The spatial lag imputation is performed only on `NA` values of the input
#' vector `x`. The imputation is based on the spatial relationships specified
#' by the `nb` parameter, using the mean value of the neighboring zones for
#' imputation. This ensures that the imputed value is spatially coherent with
#' the nearby observations.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(sf)
#' library(sfdep)
#'
#' set.seed(123)
#'
#' nc <- st_read(system.file("shape/nc.shp", package="sf"))
#'
#' p1 <- st_sample(nc[1:3, ], 100) %>% st_sf()
#' p1$random_vals <- sample(c(rnorm(5), NA), size = nrow(p1), replace = TRUE)
#'
#' p1 <- p1 %>%
#'         mutate(nb = st_knn(geometry, 3),
#'                impute_median = st_impute_lag(x, nb, FUN = median)
#'  )
#' }
#'
#' @return A numeric vector of identical length to `x`, where `NA` values have
#'    been imputed using the spatial lag of neighboring observations.
#' @export
#' @family spatial_stats
#'
#' @return A numeric vector of identical length to `x`, where `NA` values have
#'    been imputed using the spatial lag of neighboring observations computed
#'    using function `FUN`.
#' @export
#' @family spatial_stats
#'
st_impute_lag <- function(x, nb, FUN = mean, na_okay = FALSE, allow_zero = NULL, ...){
  x <- ifelse(is.na(x), purrr::map_dbl(find_xj(x, nb), FUN, na.rm = TRUE, ...), x)
}
