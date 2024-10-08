% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autoproxy_run.R
\name{autoproxy_run}
\alias{autoproxy_run}
\title{使用代理设置运行函数并在多个代理端口之间重试}
\usage{
autoproxy_run(f, proxy_ports = c(1086, 7890))
}
\arguments{
\item{f}{要在代理设置下执行的函数。}

\item{proxy_ports}{代理端口列表。默认为 c(1086, 7890)。}
}
\value{
执行函数的结果，如果发生错误则返回 NULL。
}
\description{
此函数在指定的代理设置下执行给定的函数。
它会临时设置代理环境变量，测试代理，然后运行提供的函数。
如果代理失败，会尝试下一个代理端口，直到所有端口都尝试过。
如果所有代理都失败，则取消代理并执行函数。
}
\examples{
autoproxy_run(function() {
  httr::GET("https://api.github.com/users/hadley")
}, proxy_ports = c(1086, 7890))
}
\author{
Fan Xingfu
}
