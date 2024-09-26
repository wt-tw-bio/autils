# Generated from create-autils.rmd: do not edit by hand

#' @title 全面检查基因表达矩阵
#' @description 对基因表达矩阵进行全面检查，包括数据类型、质量、分布特征等，并提供详细的分析建议。
#' @param expr_matrix 输入的基因表达矩阵，可以是 data.frame、matrix 等格式。约定行为基因，列为样本。
#' @param species 可选参数，指定物种名称（如"human", "mouse"等），用于检查 housekeeping 基因。
#' @param housekeeping_genes 可选参数，用于检查 housekeeping 基因。
#' @return 无返回值，函数会在控制台打印相关检查结果和优化建议。
#' @import crayon
#' @author Fan Xingfu
#' @export
check_expr <- function(expr_matrix, species = NULL, housekeeping_genes = NULL) {
  options(width = min(getOption("width"), 120))
  suggestions <- character()
  print_header <- function(text) {
    cat(bold(blue(paste0("\n", text, "\n", strrep("=", nchar(text)), "\n"))))
  }
  print_subheader <- function(text) {
    cat(bold(cyan(paste0("\n", text, "\n", strrep("-", nchar(text)), "\n"))))
  }
  add_suggestion <- function(text) {
    suggestions <<- c(suggestions, text)
  }
  print_header("基因表达矩阵全面检查报告")
  # 1. 基本信息检查
  print_subheader("1. 基本信息")
  cat("数据类型:", paste(class(expr_matrix), collapse = ", "), "\n")
  cat(
    "维度:", paste(dim(expr_matrix), collapse = " x "),
    "(", green(nrow(expr_matrix)), "个基因,",
    green(ncol(expr_matrix)), "个样本)\n"
  )

  # 2. 数据类型和结构检查
  print_subheader("2. 数据类型和结构检查")

  expr_matrix <- as.data.frame(expr_matrix, stringsAsFactors = FALSE)
  # 初始化基因名和样本名
  gene_ids <- NULL
  sample_ids <- NULL

  # 检查第一列是否为非数值型，假定为基因ID
  first_col_non_numeric <- !is.numeric(expr_matrix[[1]])

  if (first_col_non_numeric) {
    gene_ids <- as.character(expr_matrix[[1]])
    expr_matrix <- expr_matrix[, -1, drop = FALSE]
    cat("第一列非数值型，已将第一列视作基因ID。\n")
  } else {
    # 如果第一列为数值型，检查行名是否存在
    if (!is.null(rownames(expr_matrix))) {
      gene_ids <- rownames(expr_matrix)
      cat("检测到行名，假定为基因ID。\n")
    } else {
      cat(red("警告: 行名缺失，且第一列为数值型，无法确定基因ID。\n"))
      add_suggestion("请确保基因ID作为行名或第一列包含非数值型的基因ID。")
    }
  }

  # 检查列名是否存在
  if (!is.null(colnames(expr_matrix))) {
    sample_ids <- colnames(expr_matrix)
    cat("检测到列名，假定为样本ID。\n")
  } else {
    cat(red("警告: 列名缺失，无法确定样本ID。\n"))
    add_suggestion("请确保样本名作为列名。")
  }
  cat("------------\n")

  # 检查基因名的唯一性
  if (!is.null(gene_ids)) {
    duplicate_genes <- duplicated(gene_ids)
    if (any(duplicate_genes)) {
      cat(red("警告: 存在重复的基因名。\n"))
      print(gene_ids[which(duplicate_genes)])
      expr_matrix <- expr_matrix[!duplicate_genes, , drop = FALSE]
      gene_ids <- gene_ids[!duplicate_genes]
    } else {
      cat("基因名检查通过，无重复。\n")
    }
  }
  # 检查样本名的唯一性
  if (!is.null(sample_ids)) {
    duplicate_samples <- duplicated(sample_ids)
    if (any(duplicate_samples)) {
      cat(red("警告: 存在重复的样本名。\n"))
      print(sample_ids[which(duplicate_samples)])
      add_suggestion("请检查样本名的唯一性，必要时进行更正。")
    } else {
      cat("样本名检查通过，无重复。\n")
    }
  }
  # 将基因ID和样本ID设置为行名和列名
  if (!is.null(gene_ids)) {
    rownames(expr_matrix) <- gene_ids
  }
  if (!is.null(sample_ids)) {
    colnames(expr_matrix) <- sample_ids
  }
  # 检查数据是否为数值型，尝试转换
  non_numeric_cols <- sapply(expr_matrix, function(x) !is.numeric(x) && !all(is.na(x)))
  if (any(non_numeric_cols)) {
    cat(red("警告: 存在非数值列。尝试转换为数值型...\n"))
    for (col in names(expr_matrix)[non_numeric_cols]) {
      expr_matrix[[col]] <- as.numeric(as.character(expr_matrix[[col]]))
    }
    # 再次检查是否还有非数值列
    still_non_numeric <- sapply(expr_matrix, function(x) !is.numeric(x) && !all(is.na(x)))
    if (any(still_non_numeric)) {
      cat(red("警告: 以下列无法转换为数值型，将从分析中移除。\n"))
      print(names(expr_matrix)[still_non_numeric])
      expr_matrix <- expr_matrix[, !still_non_numeric, drop = FALSE]
      add_suggestion("已移除无法转换为数值型的列。")
    } else {
      cat("所有列成功转换为数值型。\n")
    }
  } else {
    cat("所有列均为数值型。\n")
  }

  # 将数据转换为数值矩阵
  data_values <- as.matrix(expr_matrix)

  # 检查是否存在负值
  if (any(data_values < 0, na.rm = TRUE)) {
    cat(red("警告: 数据中存在负值。\n"))
    add_suggestion("基因表达矩阵中不应存在负值，请检查数据来源和处理步骤。")
  } else {
    cat("负值检查通过，无负值。\n")
  }

  # 检查是否存在缺失值
  missing_values <- sum(is.na(data_values))
  if (missing_values > 0) {
    cat("缺失值总数:", missing_values, "\n")
    missing_proportion <- missing_values / (nrow(data_values) * ncol(data_values))
    cat("缺失值比例:", sprintf("%.2f%%", missing_proportion * 100), "\n")
    if (missing_proportion > 0.05) {
      cat(red("警告: 缺失值比例较高。\n"))
      add_suggestion("考虑对缺失值进行适当处理，如填充、删除或评估其对下游分析的影响。")
    } else {
      cat("缺失值比例在可接受范围内。\n")
    }
  } else {
    cat("无缺失值。\n")
  }

  # 检查是否存在全为NA的行或列
  na_rows <- which(rowSums(is.na(data_values)) == ncol(data_values))
  na_cols <- which(colSums(is.na(data_values)) == nrow(data_values))
  if (length(na_rows) > 0) {
    cat(red("警告: 存在全为NA的行。\n"))
    print(rownames(data_values)[na_rows])
    add_suggestion("考虑移除全为NA的行，这些可能是无效的基因或探针。")
  } else {
    cat("无全为NA的行。\n")
  }

  if (length(na_cols) > 0) {
    cat(red("警告: 存在全为NA的列。\n"))
    print(colnames(data_values)[na_cols])
    add_suggestion("检查并可能需要移除全为NA的样本列。")
  } else {
    cat("无全为NA的列。\n")
  }

  # 3. 数据分布检查
  print_subheader("3. 数据分布检查")

  # 检查是否为counts矩阵
  is_integer_matrix <- all(floor(data_values) == data_values, na.rm = TRUE) && all(data_values >= 0, na.rm = TRUE)
  if (is_integer_matrix) {
    cat(green("检测到 counts 矩阵。\n"))
    cat("该矩阵适合用于 DESeq2 或 edgeR 进行差异表达分析。\n")
    add_suggestion("对于 counts 矩阵，建议使用 DESeq2 或 edgeR 进行差异表达分析。")
    add_suggestion("如需进行其他分析或绘图，建议将 counts 数据转换为 TPM 或 FPKM。")

    # 检查 counts 矩阵的分布
    zero_prop <- sum(data_values == 0, na.rm = TRUE) / length(data_values)
    if (zero_prop > 0.8) {
      cat(red("警告: 零值比例过高 (", sprintf("%.2f%%", zero_prop * 100), ")。\n"))
      add_suggestion("考虑使用适当的过滤方法去除低表达基因，或考虑是否存在测序深度不足的问题。")
    } else {
      cat("零值比例在可接受范围内。\n")
    }

    # 检查每个样本的总 counts
    total_counts <- colSums(data_values, na.rm = TRUE)
    cat("\n每个样本的总 counts 值:\n")
    print(total_counts)
    median_counts <- median(total_counts, na.rm = TRUE)
    low_count_samples <- names(total_counts)[total_counts < median_counts / 2]
    if (length(low_count_samples) > 0) {
      cat(red("警告: 以下样本的总 counts 值显著低于中位数的一半:\n"))
      print(low_count_samples)
      add_suggestion("低测序深度的样本可能会影响分析结果，考虑是否需要剔除或重新测序。")
    } else {
      cat("所有样本的总 counts 值在正常范围内。\n")
    }
  } else {
    cat(yellow("检测到非 counts 矩阵。\n"))

    # 判断是否需要对数转换
    ex <- data_values[!is.na(data_values) & data_values != Inf & data_values != -Inf]
    qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0)))
    LogC <- (qx[5] > 100) ||
      (qx[6] - qx[1] > 50 && qx[2] > 0) ||
      (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
    if (LogC) {
      cat(yellow("建议对数据进行对数转换 (如 log2(x + 1))。\n"))
      add_suggestion("在进行下游分析前，建议对数据进行对数转换 (如 log2(x + 1))。")
    } else {
      cat(green("数据可能已经过对数转换，无需再次转换。\n"))
    }

    # 检查每个样本的表达值分布
    sample_means <- colMeans(data_values, na.rm = TRUE)
    sample_medians <- apply(data_values, 2, median, na.rm = TRUE)
    cat("\n样本的均值和中位数:\n")
    print(data.frame(Sample = colnames(data_values), Mean = sample_means, Median = sample_medians))
    mean_median <- median(sample_means, na.rm = TRUE)
    low_expr_samples <- names(sample_means)[sample_means < mean_median / 2]
    if (length(low_expr_samples) > 0) {
      cat(red("警告: 以下样本的平均表达值显著低于中位数的一半:\n"))
      print(low_expr_samples)
      add_suggestion("平均表达水平低的样本可能存在质量问题，需进一步检查。")
    } else {
      cat("所有样本的平均表达值在正常范围内。\n")
    }
  }

  # 4. 缺失值检查
  print_subheader("4. 缺失值检查")

  missing_values_per_sample <- colSums(is.na(data_values))
  if (any(missing_values_per_sample > 0)) {
    cat("每个样本的缺失值数量:\n")
    print(missing_values_per_sample[missing_values_per_sample > 0])
    add_suggestion("存在缺失值的样本可能需要进行处理或移除。")
  } else {
    cat("所有样本均无缺失值。\n")
  }

  missing_values_per_gene <- rowSums(is.na(data_values))
  if (any(missing_values_per_gene > 0)) {
    cat("每个基因的缺失值数量:\n")
    print(missing_values_per_gene[missing_values_per_gene > 0])
    add_suggestion("存在缺失值的基因可能需要进行处理或移除。")
  } else {
    cat("所有基因均无缺失值。\n")
  }

  # 5. 异常值检查
  print_subheader("5. 异常值检查")

  # 使用 IQR 方法检测异常值
  is_outlier <- function(x) {
    qnt <- quantile(x, probs = c(.25, .75), na.rm = TRUE)
    H <- 1.5 * IQR(x, na.rm = TRUE)
    x < (qnt[1] - H) | x > (qnt[2] + H)
  }

  outliers <- apply(data_values, 2, is_outlier)
  outlier_prop <- colSums(outliers, na.rm = TRUE) / nrow(data_values)
  cat("使用的阈值: IQR 方法的 1.5 倍\n")
  if (any(outlier_prop > 0.1)) {
    cat(crayon::red("警告: 某些样本存在较高比例的异常值。\n"))
    print(outlier_prop[outlier_prop > 0.1])
    add_suggestion("检查异常值较多的样本，考虑是否存在技术性偏差或生物学意义。")
  } else {
    cat("所有样本的异常值比例在正常范围内。\n")
  }

  # 6. 样本相关性检查
  print_subheader("6. 样本相关性检查")

  cor_matrix <- cor(data_values, use = "pairwise.complete.obs")
  low_cor <- which(cor_matrix < 0.7 & cor_matrix != 1, arr.ind = TRUE)
  cat("使用的阈值: 相关性 < 0.7\n")
  if (nrow(low_cor) > 0) {
    cat(crayon::yellow("注意: 存在相关性较低的样本对。\n"))
    print(head(low_cor))
    add_suggestion("检查相关性较低的样本对，考虑是否存在批次效应或样本异常。")
  } else {
    cat("所有样本之间的相关性良好。\n")
  }

  # 7. 基因表达水平检查
  print_subheader("7. 基因表达水平检查")

  row_means <- rowMeans(data_values, na.rm = TRUE)
  low_expr_genes <- sum(row_means < 1, na.rm = TRUE)
  cat("使用的阈值: 基因平均表达水平 < 1\n")
  if (low_expr_genes / nrow(data_values) > 0.5) {
    cat(crayon::yellow("注意: 大量基因表达水平较低。\n"))
    cat("低表达基因比例:", sprintf("%.2f%%", low_expr_genes / nrow(data_values) * 100), "\n")
    add_suggestion("考虑对低表达基因进行过滤，或检查是否存在数据预处理问题。")
  } else {
    cat("低表达基因比例在可接受范围内。\n")
  }


  # 检查零方差基因
  zero_variance_genes <- apply(data_values, 1, function(x) var(x, na.rm = TRUE) == 0)

  # 将 NA 值替换为 FALSE
  zero_variance_genes[is.na(zero_variance_genes)] <- FALSE

  if (any(zero_variance_genes)) {
    cat(crayon::yellow("注意: 存在在所有样本中表达值相同的基因（零方差）。\n"))
    cat("零方差基因数量:", sum(zero_variance_genes), "\n")
    add_suggestion("对零方差基因可考虑在下游分析中去除，因他们对差异比较没有贡献，还可能会导致PCA等计算失败。")
  } else {
    cat("不存在零方差基因")
  }

  # 8. 批次效应检查
  print_subheader("8. 批次效应检查")
  if (ncol(data_values) > 5) {
    tryCatch(
      {
        pca_result <- prcomp(t(data_values), scale. = TRUE)
        pc1_var <- summary(pca_result)$importance[2, 1]
        cat("使用的阈值: 第一主成分解释的方差比例 > 50%\n")
        if (pc1_var > 0.5) {
          cat(crayon::yellow("注意: 可能存在明显的批次效应。\n"))
          cat("第一主成分解释的方差比例:", sprintf("%.2f%%", pc1_var * 100), "\n")
          add_suggestion("建议进行批次效应校正，或检查样本分组是否合理。")
        } else {
          cat("第一主成分解释的方差比例在可接受范围内。\n")
        }
        cat("已计算样本的层次聚类，请查看聚类结果以确定是否存在批次效应或异常样本。\n")
        add_suggestion("建议绘制样本的聚类树，以直观地检查样本之间的关系。")
      },
      error = function(e) {
        cat(crayon::yellow("无法进行PCA分析，可能是由于数据中存在NA值或其他问题。\n"))
        add_suggestion("建议检查数据中的NA值或异常值，并考虑进行适当的预处理。")
      }
    )
  } else {
    cat("样本数量较少（<=5），无法进行可靠的批次效应检查。\n")
    add_suggestion("建议增加样本数量以进行更可靠的批次效应分析。")
  }

  # 9. Housekeeping 基因检查
  # 辅助函数：获取 housekeeping 基因列表（示例）

  print_subheader("9. Housekeeping 基因检查")
  if (!is.null(species)) {
    if (length(housekeeping_genes) > 0) {
      hk_expr <- data_values[rownames(data_values) %in% housekeeping_genes, , drop = FALSE]
      if (nrow(hk_expr) > 0) {
        hk_means <- rowMeans(hk_expr, na.rm = TRUE)
        cat("Housekeeping 基因的平均表达水平:\n")
        print(hk_means)
        if (any(hk_means < quantile(row_means, 0.25, na.rm = TRUE))) {
          cat(crayon::yellow("注意: 部分 housekeeping 基因表达水平较低。\n"))
          add_suggestion("检查 housekeeping 基因的表达水平，考虑是否存在样本质量问题。")
        }
      } else {
        cat(crayon::yellow("未找到匹配的 housekeeping 基因。\n"))
        add_suggestion("检查基因名称格式是否与参考基因组一致。")
      }
    } else {
      cat("未提供指定物种的 housekeeping 基因列表。\n")
      add_suggestion("考虑为该物种添加 housekeeping 基因列表以进行更全面的检查。")
    }
  } else {
    cat("未提供物种信息，无法进行 housekeeping 基因检查。\n")
    add_suggestion("提供物种信息以进行 housekeeping 基因检查，可以更全面地评估数据质量。")
  }

  # 10. 变异系数（CV）检查
  print_subheader("10. 变异系数检查")
  cv <- apply(data_values, 1, function(x) sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE))
  high_cv_genes <- sum(cv > 1, na.rm = TRUE)
  cv_proportion <- high_cv_genes / length(cv)
  cat("高变异系数基因比例:", sprintf("%.2f%%", cv_proportion * 100), "\n")
  if (cv_proportion > 0.2) {
    cat(crayon::yellow("注意: 大量基因的变异系数较高。\n"))
    add_suggestion("检查高变异系数的基因，考虑是否存在生物学意义或技术性偏差。")
  } else {
    cat("大多数基因的变异系数在正常范围内。\n")
  }

  # 打印优化建议
  if (length(suggestions) > 0) {
    print_header("优化建议")
    for (i in seq_along(suggestions)) {
      cat(crayon::bold(crayon::green(paste0(i, ". "))), suggestions[i], "\n")
    }
  } else {
    cat("\n", crayon::green("未发现需要特别优化的地方，数据质量良好。\n"))
  }

  cat("\n", crayon::bold(crayon::blue("检查报告生成完毕")), "\n")
}
