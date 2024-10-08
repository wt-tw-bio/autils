% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_expr.R
\name{check_expr}
\alias{check_expr}
\title{全面检查基因表达矩阵}
\usage{
check_expr(expr_matrix, species = NULL, housekeeping_genes = NULL)
}
\arguments{
\item{expr_matrix}{输入的基因表达矩阵，可以是 data.frame、matrix 等格式。约定行为基因，列为样本。}

\item{species}{可选参数，指定物种名称（如"human", "mouse"等），用于检查 housekeeping 基因。}

\item{housekeeping_genes}{可选参数，用于检查 housekeeping 基因。}
}
\value{
无返回值，函数会在控制台打印相关检查结果和优化建议。
}
\description{
对基因表达矩阵进行全面检查，包括数据类型、质量、分布特征等，并提供详细的分析建议。
}
\examples{
# 安装并加载必要的包
# install.packages("impute")
# install.packages("matrixStats")

# 示例代码
cars
autils::check_expr(cars)

iris
autils::check_expr(iris)
}
\author{
Fan Xingfu
}
