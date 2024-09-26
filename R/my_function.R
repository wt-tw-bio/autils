
#' @title：用于描述函数的标题或名称。
#' @description：提供该函数的简短描述。
#' @param：列出函数的输入参数以及对每个参数的详细解释。
#' @return：说明函数的返回值。
#' @usage：给出函数的用法示例。
#' @examples：提供函数的使用示例代码。
#' @details：进一步详细说明函数的工作机制和细节。
#' @keywords：列出与函数相关的关键词，以便在文档中进行索引。
#' @import：声明该函数依赖的外部包。
#' @importFrom：声明该函数依赖的外部包中的特定函数。
#' @importFrom rlang .data：引用数据框列名，避免 R CMD check 注意
#' @export：表明函数将被导出，供用户使用。
#' 
a = function(x){x+1}