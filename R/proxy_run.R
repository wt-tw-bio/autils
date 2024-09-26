# Generated from create-autils.rmd: do not edit by hand

#' 使用代理设置运行函数
#'
#' 此函数在指定的代理设置下执行给定的函数。
#' 它会临时设置代理环境变量，测试代理，然后运行提供的函数。
#'
#' @param f 要在代理设置下执行的函数。
#' @param http_proxy HTTP 代理 URL。默认为 "http://localhost:1086"。
#' @param https_proxy HTTPS 代理 URL。默认为 "http://localhost:1086"。
#' @return 执行函数的结果，如果发生错误则返回 NULL。
#' @examples
#' proxy_run(function() {
#'   httr::GET("https://api.github.com/users/hadley")
#' })
#' @import xml2
#' @import httr
#' @importFrom withr with_envvar
#' @importFrom crayon red green blue yellow
#' @author Fan Xingfu
#' @export
proxy_run <- function(f, http_proxy = "http://localhost:1086", https_proxy = "http://localhost:1086") {
  necessary_packages <- c("crayon", "withr", "httr", "xml2")
  installed_packages <- rownames(installed.packages())
  for (pkg in necessary_packages) {
    if (!pkg %in% installed_packages) {
      install.packages(pkg)
    }
  }
  cat(green$bold("准备使用代理执行指定的函数...\n"))

  # 在新环境中设置代理并执行函数
  result <- with_envvar(
    new = c(http_proxy = http_proxy, https_proxy = https_proxy),
    code = {
      cat(green$bold("已将代理设置为："), http_proxy, "\n")

      # 测试代理是否可用
      proxy_test <- tryCatch(
        {
          test_response <- httr::GET("https://api.github.com/users/hadley")
          if (test_response$status_code != 200) {
            stop("代理测试失败，无法访问目标网址。")
          }
          cat(green$bold("代理测试成功，能够访问互联网。\n"))
        },
        error = function(e) {
          cat(red$bold("代理测试失败："), e$message, "\n")
          stop("代理不可用，请检查代理设置。")
        }
      )

      # 执行用户指定的函数
      cat(blue$bold("开始执行指定的函数...\n"))
      tryCatch(
        {
          res <- f()
          cat(green$bold("函数执行成功！\n"))
          res # 返回结果
        },
        error = function(e) {
          cat(red$bold("函数执行出错："), e$message, "\n")
          NULL # 返回空结果
        },
        warning = function(w) {
          cat(yellow$bold("警告："), w$message, "\n")
          invokeRestart("muffleWarning") # 忽略警告继续执行
        }
      )
    }
  )

  cat(green$bold("已恢复之前的代理设置。\n"))

  return(result)
}
