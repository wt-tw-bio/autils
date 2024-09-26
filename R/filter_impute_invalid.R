#' @title 数据清洗与可选插补
#' @description 清理数据，并可选择是否使用 KNN 方法进行缺失值插补
#' @param matrix 输入的数值矩阵
#' @param row_invalid_threshold 行非法值比例阈值，默认为 0.6
#' @param col_invalid_threshold 列非法值比例阈值，默认为 0.8
#' @param mean_threshold 行平均值阈值，默认为 0.05
#' @param sd_threshold 行标准差阈值，默认为 0.01
#' @param perform_imputation 是否执行 KNN 插补，默认为 TRUE
#' @return 清洗（和可能插补）后的矩阵
#' @details 此函数首先计算每行和每列中非法值（零值、`NA`、`NaN`、`Inf`）的比例，并根据设定的阈值移除包含过多非法值的行和列。
#' 如果 `perform_imputation` 为 TRUE，则使用 KNN 方法进行缺失值插补。
#' 然后移除低表达（平均值低于 `mean_threshold`）和低变异（标准差低于 `sd_threshold`）的行。
#' @usage filter_impute_invalid(matrix, row_invalid_threshold = 0.6, col_invalid_threshold = 0.8, mean_threshold = 0.05, sd_threshold = 0.01, perform_imputation = TRUE)
#' @examples
#'
#' # 安装并加载必要的包
#' # install.packages("impute")
#' # install.packages("matrixStats")
#'
#' # 创建一个示例矩阵
#' set.seed(123)
#' data <- matrix(runif(100, 0, 1), nrow = 10)
#' data[sample(100, 10)] <- 0 # 添加一些零值
#' data[sample(100, 5)] <- NA # 添加一些 NA 值
#' data[sample(100, 5)] <- Inf # 添加一些 Inf 值
#' data[sample(100, 5)] <- NaN # 添加一些 NaN 值
#'
#' # 清洗并插补数据
#' cleaned_data <- filter_impute_invalid(data)
#' # 仅清洗数据，不进行插补
#' cleaned_data_no_impute <- filter_impute_invalid(data, perform_imputation = FALSE)
#' @import impute
#' @import matrixStats
#' @author Fan Xingfu
#' @export
filter_impute_invalid <- function(matrix, row_invalid_threshold = 0.6, col_invalid_threshold = 0.8, mean_threshold = 0.05, sd_threshold = 0.01, perform_imputation = TRUE) {
  # 检查并加载必要的包
  if (!requireNamespace("impute", quietly = TRUE)) {
    stop("需要'impute'包。请先安装它：install.packages('impute')")
  }
  if (!requireNamespace("matrixStats", quietly = TRUE)) {
    stop("需要'matrixStats'包。请先安装它：install.packages('matrixStats')")
  }

  # 定义非法值（零值、NA、NaN、Inf）
  is_invalid <- function(x) {
    is.na(x) | x == 0 | is.nan(x) | is.infinite(x)
  }

  # 计算每行非法值的比例
  row_invalid_proportion <- rowMeans(is_invalid(matrix), na.rm = TRUE)
  # 移除非法值比例超过阈值的行
  matrix <- matrix[row_invalid_proportion < row_invalid_threshold, , drop = FALSE]

  # 计算每列非法值的比例
  col_invalid_proportion <- colMeans(is_invalid(matrix), na.rm = TRUE)
  # 移除非法值比例超过阈值的列
  matrix <- matrix[, col_invalid_proportion < col_invalid_threshold, drop = FALSE]

  # 如果选择进行插补，则执行 KNN 插补
  if (perform_imputation) {
    # 替换零值和 Inf 为 NA，以便 impute.knn 可以正常工作
    matrix[is_invalid(matrix)] <- NA
    matrix <- impute::impute.knn(as.matrix(matrix), rowmax = 1, colmax = 1)$data
  }

  # 移除低表达和低变异的行
  row_means <- rowMeans(matrix, na.rm = TRUE)
  matrix <- matrix[row_means > mean_threshold, , drop = FALSE]

  row_sds <- matrixStats::rowSds(matrix, na.rm = TRUE)
  matrix <- matrix[row_sds > sd_threshold, , drop = FALSE]

  return(matrix)
}
