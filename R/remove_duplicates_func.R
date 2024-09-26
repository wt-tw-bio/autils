# Generated from create-autils.rmd: do not edit by hand

#' @title 去除重复并聚合数据
#' @description 按第一列分组去除重复行，并对其他列应用指定的聚合函数
#' @param data 输入的数据框
#' @param agg_func 聚合函数，对其他列应用的函数，默认为mean
#' @return 去重并应用聚合函数后的数据框，第一列作为行名
#' @details 此函数首先按第一列对数据进行分组，然后对其他所有列应用指定的聚合函数。
#' 结果中，第一列的唯一值将作为行名，其他列为对应的聚合结果。
#' @usage remove_duplicates_func(data, agg_func = mean)
#' @examples
#' # 创建一个示例数据框
#' data <- data.frame(ID = c("A", "A", "B", "B"), Value1 = 1:4, Value2 = 5:8)
#' # 去除重复并计算均值
#' unique_data_mean <- remove_duplicates_func(data)
#' print(unique_data_mean)
#' # 使用最大值
#' unique_data_max <- remove_duplicates_func(data, max)
#' print(unique_data_max)
#' # 使用中位数
#' unique_data_median <- remove_duplicates_func(data, median)
#' print(unique_data_median)
#' # 使用自定义函数（例如，计算范围）
#' unique_data_range <- remove_duplicates_func(data, function(x) max(x) - min(x))
#' print(unique_data_range)
#' @import dplyr
#' @importFrom rlang .data
#' @importFrom tibble column_to_rownames
#' @author Fan Xingfu
#' @export
remove_duplicates_func <- function(data, agg_func = mean) {
  data %>%
    group_by(.data[[names(data)[1]]]) %>%
    summarize(across(.cols = where(is.numeric), .fns = agg_func)) %>%
    column_to_rownames(var = names(data)[1])
}
