# Generated from create-autils.rmd: do not edit by hand

#' @title 按中位数分组
#' @description 将指定的数值列按其中位数分为高低两组
#' @param data 包含要分组的数值列的数据框
#' @param column_name 要分组的列名（字符串）
#' @return 添加了分组列的新数据框
#' @details 此函数计算指定列的中位数，然后创建一个新的列，
#' 将大于中位数的值标记为'high'，小于或等于中位数的值标记为'low'。
#' 新列的名称为原列名加上"_group"后缀。
#' @usage group_by_median(data, column_name)
#' @examples
#' # 创建一个示例数据框
#' data <- data.frame(ID = 1:10, Value = runif(10))
#' # 按Value列的中位数进行分组
#' grouped_data <- group_by_median(data, "Value")
#' print(grouped_data)
#' @author Fan Xingfu
#' @export
group_by_median <- function(data, column_name) {
  data[[paste0(column_name, "_group")]] <- ifelse(
    data[[column_name]] > median(data[[column_name]], na.rm = TRUE),
    'high', 'low'
  )
  return(data)
}
