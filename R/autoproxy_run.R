# Generated from create-autils.rmd: do not edit by hand

#' 使用代理设置运行函数并在多个代理端口之间重试
#'
#' 此函数在指定的代理设置下执行给定的函数。
#' 它会临时设置代理环境变量，测试代理，然后运行提供的函数。
#' 如果代理失败，会尝试下一个代理端口，直到所有端口都尝试过。
#' 如果所有代理都失败，则取消代理并执行函数。
#'
#' @param f 要在代理设置下执行的函数。
#' @param proxy_ports 代理端口列表。默认为 c(1086, 7890)。
#' @return 执行函数的结果，如果发生错误则返回 NULL。
#' @author Fan Xingfu
#' @import withr
#' @export
#' @examples
#' autoproxy_run(function() {
#'   httr::GET("https://api.github.com/users/hadley")
#' }, proxy_ports = c(1086, 7890))
autoproxy_run <- function(f, proxy_ports = c(1086, 7890)) {

  cat(cyan$bold("✿ 准备使用代理执行指定的函数...\n"))

  # 定义一个内部函数来测试代理并执行用户函数
  run_with_proxy <- function(http_proxy, https_proxy) {
    cat(yellow$bold("❀ 已将代理设置为："), green(http_proxy), "\n")

    # 测试代理是否可用
    proxy_test <- tryCatch(
      {
        test_response <- httr::GET("https://api.github.com/users/hadley")
        if (test_response$status_code != 200) {
          stop("代理测试失败，无法访问目标网址。")
        }
        cat(green$bold("✿ 代理测试成功，能够访问互联网。\n"))
        TRUE
      },
      error = function(e) {
        cat(red$bold("❀ 代理测试失败："), e$message, "\n")
        FALSE
      }
    )

    if (!proxy_test) {
      return(NULL)
    }

    # 执行用户指定的函数
    cat(cyan$bold("✿ 开始执行指定的函数...\n"))
    result <- tryCatch(
      {
        res <- f()
        cat(green$bold("❀ 函数执行成功！\n"))
        res  # 返回结果
      },
      error = function(e) {
        cat(red$bold("✿ 函数执行出错："), e$message, "\n")
        NULL  # 返回空结果
      },
      warning = function(w) {
        cat(yellow$bold("❀ 警告："), w$message, "\n")
        invokeRestart("muffleWarning")  # 忽略警告继续执行
      }
    )
    return(result)
  }

  # 尝试每个代理端口
  for (port in proxy_ports) {
    http_proxy <- paste0("http://localhost:", port)
    https_proxy <- paste0("http://localhost:", port)
    result <- withr::with_envvar(
      new = c(http_proxy = http_proxy, https_proxy = https_proxy),
      code = run_with_proxy(http_proxy, https_proxy)
    )
    if (!is.null(result)) {
      cat(green$bold("✿ 已恢复之前的代理设置。\n"))
      return(result)
    }
    cat(yellow$bold("❀ 当前代理失败，尝试下一个端口...\n"))
  }

  # 如果所有代理都失败，取消代理并执行函数
  cat(red$bold("✿ 所有代理都失败，尝试不使用代理执行函数。\n"))
  result <- withr::with_envvar(
    new = c(http_proxy = "", https_proxy = ""),
    code = run_with_proxy("", "")
  )
  cat(cyan$bold("❀ 已恢复之前的代理设置。\n"))
  return(result)
}

