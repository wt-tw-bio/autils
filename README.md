
<!-- README.md is generated from README.Rmd. Please edit that file -->

# autils

<!-- badges: start -->

[![R-CMD-check](https://github.com/wt-tw-bio/autils/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/wt-tw-bio/autils/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/wt-tw-bio/autils/branch/main/graph/badge.svg)](https://app.codecov.io/gh/wt-tw-bio/autils?branch=main)

<!-- badges: end -->

The goal of autils is to …

## Installation

You can install the development version of autils from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("wt-tw-bio/autils")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(autils)
#> Warning: replacing previous import 'crayon::%+%' by 'ggplot2::%+%' when loading
#> 'autils'
#> Warning: replacing previous import 'dplyr::count' by 'matrixStats::count' when
#> loading 'autils'
#> 
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

``` r
cars
#>    speed dist
#> 1      4    2
#> 2      4   10
#> 3      7    4
#> 4      7   22
#> 5      8   16
#> 6      9   10
#> 7     10   18
#> 8     10   26
#> 9     10   34
#> 10    11   17
#> 11    11   28
#> 12    12   14
#> 13    12   20
#> 14    12   24
#> 15    12   28
#> 16    13   26
#> 17    13   34
#> 18    13   34
#> 19    13   46
#> 20    14   26
#> 21    14   36
#> 22    14   60
#> 23    14   80
#> 24    15   20
#> 25    15   26
#> 26    15   54
#> 27    16   32
#> 28    16   40
#> 29    17   32
#> 30    17   40
#> 31    17   50
#> 32    18   42
#> 33    18   56
#> 34    18   76
#> 35    18   84
#> 36    19   36
#> 37    19   46
#> 38    19   68
#> 39    20   32
#> 40    20   48
#> 41    20   52
#> 42    20   56
#> 43    20   64
#> 44    22   66
#> 45    23   54
#> 46    24   70
#> 47    24   92
#> 48    24   93
#> 49    24  120
#> 50    25   85
autils::check_expr(cars)
#> 
#> 基因表达矩阵全面检查报告
#> ============
#> 
#> 1. 基本信息
#> -------
#> 数据类型: data.frame 
#> 维度: 50 x 2 ( 50 个基因, 2 个样本)
#> 
#> 2. 数据类型和结构检查
#> ------------
#> 检测到行名，假定为基因ID。
#> 检测到列名，假定为样本ID。
#> ------------
#> 基因名检查通过，无重复。
#> 样本名检查通过，无重复。
#> 所有列均为数值型。
#> 负值检查通过，无负值。
#> 无缺失值。
#> 无全为NA的行。
#> 无全为NA的列。
#> 
#> 3. 数据分布检查
#> ---------
#> 检测到 counts 矩阵。
#> 该矩阵适合用于 DESeq2 或 edgeR 进行差异表达分析。
#> 零值比例在可接受范围内。
#> 
#> 每个样本的总 counts 值:
#> speed  dist 
#>   770  2149 
#> 所有样本的总 counts 值在正常范围内。
#> 
#> 4. 缺失值检查
#> --------
#> 所有样本均无缺失值。
#> 所有基因均无缺失值。
#> 
#> 5. 异常值检查
#> --------
#> 使用的阈值: IQR 方法的 1.5 倍
#> 所有样本的异常值比例在正常范围内。
#> 
#> 6. 样本相关性检查
#> ----------
#> 使用的阈值: 相关性 < 0.7
#> 所有样本之间的相关性良好。
#> 
#> 7. 基因表达水平检查
#> -----------
#> 使用的阈值: 基因平均表达水平 < 1
#> 低表达基因比例在可接受范围内。
#> 不存在零方差基因
#> 8. 批次效应检查
#> ---------
#> 样本数量较少（<=5），无法进行可靠的批次效应检查。
#> 
#> 9. Housekeeping 基因检查
#> --------------------
#> 未提供物种信息，无法进行 housekeeping 基因检查。
#> 
#> 10. 变异系数检查
#> ----------
#> 高变异系数基因比例: 0.00% 
#> 大多数基因的变异系数在正常范围内。
#> 
#> 优化建议
#> ====
#> 1.  对于 counts 矩阵，建议使用 DESeq2 或 edgeR 进行差异表达分析。 
#> 2.  如需进行其他分析或绘图，建议将 counts 数据转换为 TPM 或 FPKM。 
#> 3.  建议增加样本数量以进行更可靠的批次效应分析。 
#> 4.  提供物种信息以进行 housekeeping 基因检查，可以更全面地评估数据质量。 
#> 
#>  检查报告生成完毕
```

``` r
iris
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1            5.1         3.5          1.4         0.2     setosa
#> 2            4.9         3.0          1.4         0.2     setosa
#> 3            4.7         3.2          1.3         0.2     setosa
#> 4            4.6         3.1          1.5         0.2     setosa
#> 5            5.0         3.6          1.4         0.2     setosa
#> 6            5.4         3.9          1.7         0.4     setosa
#> 7            4.6         3.4          1.4         0.3     setosa
#> 8            5.0         3.4          1.5         0.2     setosa
#> 9            4.4         2.9          1.4         0.2     setosa
#> 10           4.9         3.1          1.5         0.1     setosa
#> 11           5.4         3.7          1.5         0.2     setosa
#> 12           4.8         3.4          1.6         0.2     setosa
#> 13           4.8         3.0          1.4         0.1     setosa
#> 14           4.3         3.0          1.1         0.1     setosa
#> 15           5.8         4.0          1.2         0.2     setosa
#> 16           5.7         4.4          1.5         0.4     setosa
#> 17           5.4         3.9          1.3         0.4     setosa
#> 18           5.1         3.5          1.4         0.3     setosa
#> 19           5.7         3.8          1.7         0.3     setosa
#> 20           5.1         3.8          1.5         0.3     setosa
#> 21           5.4         3.4          1.7         0.2     setosa
#> 22           5.1         3.7          1.5         0.4     setosa
#> 23           4.6         3.6          1.0         0.2     setosa
#> 24           5.1         3.3          1.7         0.5     setosa
#> 25           4.8         3.4          1.9         0.2     setosa
#> 26           5.0         3.0          1.6         0.2     setosa
#> 27           5.0         3.4          1.6         0.4     setosa
#> 28           5.2         3.5          1.5         0.2     setosa
#> 29           5.2         3.4          1.4         0.2     setosa
#> 30           4.7         3.2          1.6         0.2     setosa
#> 31           4.8         3.1          1.6         0.2     setosa
#> 32           5.4         3.4          1.5         0.4     setosa
#> 33           5.2         4.1          1.5         0.1     setosa
#> 34           5.5         4.2          1.4         0.2     setosa
#> 35           4.9         3.1          1.5         0.2     setosa
#> 36           5.0         3.2          1.2         0.2     setosa
#> 37           5.5         3.5          1.3         0.2     setosa
#> 38           4.9         3.6          1.4         0.1     setosa
#> 39           4.4         3.0          1.3         0.2     setosa
#> 40           5.1         3.4          1.5         0.2     setosa
#> 41           5.0         3.5          1.3         0.3     setosa
#> 42           4.5         2.3          1.3         0.3     setosa
#> 43           4.4         3.2          1.3         0.2     setosa
#> 44           5.0         3.5          1.6         0.6     setosa
#> 45           5.1         3.8          1.9         0.4     setosa
#> 46           4.8         3.0          1.4         0.3     setosa
#> 47           5.1         3.8          1.6         0.2     setosa
#> 48           4.6         3.2          1.4         0.2     setosa
#> 49           5.3         3.7          1.5         0.2     setosa
#> 50           5.0         3.3          1.4         0.2     setosa
#> 51           7.0         3.2          4.7         1.4 versicolor
#> 52           6.4         3.2          4.5         1.5 versicolor
#> 53           6.9         3.1          4.9         1.5 versicolor
#> 54           5.5         2.3          4.0         1.3 versicolor
#> 55           6.5         2.8          4.6         1.5 versicolor
#> 56           5.7         2.8          4.5         1.3 versicolor
#> 57           6.3         3.3          4.7         1.6 versicolor
#> 58           4.9         2.4          3.3         1.0 versicolor
#> 59           6.6         2.9          4.6         1.3 versicolor
#> 60           5.2         2.7          3.9         1.4 versicolor
#> 61           5.0         2.0          3.5         1.0 versicolor
#> 62           5.9         3.0          4.2         1.5 versicolor
#> 63           6.0         2.2          4.0         1.0 versicolor
#> 64           6.1         2.9          4.7         1.4 versicolor
#> 65           5.6         2.9          3.6         1.3 versicolor
#> 66           6.7         3.1          4.4         1.4 versicolor
#> 67           5.6         3.0          4.5         1.5 versicolor
#> 68           5.8         2.7          4.1         1.0 versicolor
#> 69           6.2         2.2          4.5         1.5 versicolor
#> 70           5.6         2.5          3.9         1.1 versicolor
#> 71           5.9         3.2          4.8         1.8 versicolor
#> 72           6.1         2.8          4.0         1.3 versicolor
#> 73           6.3         2.5          4.9         1.5 versicolor
#> 74           6.1         2.8          4.7         1.2 versicolor
#> 75           6.4         2.9          4.3         1.3 versicolor
#> 76           6.6         3.0          4.4         1.4 versicolor
#> 77           6.8         2.8          4.8         1.4 versicolor
#> 78           6.7         3.0          5.0         1.7 versicolor
#> 79           6.0         2.9          4.5         1.5 versicolor
#> 80           5.7         2.6          3.5         1.0 versicolor
#> 81           5.5         2.4          3.8         1.1 versicolor
#> 82           5.5         2.4          3.7         1.0 versicolor
#> 83           5.8         2.7          3.9         1.2 versicolor
#> 84           6.0         2.7          5.1         1.6 versicolor
#> 85           5.4         3.0          4.5         1.5 versicolor
#> 86           6.0         3.4          4.5         1.6 versicolor
#> 87           6.7         3.1          4.7         1.5 versicolor
#> 88           6.3         2.3          4.4         1.3 versicolor
#> 89           5.6         3.0          4.1         1.3 versicolor
#> 90           5.5         2.5          4.0         1.3 versicolor
#> 91           5.5         2.6          4.4         1.2 versicolor
#> 92           6.1         3.0          4.6         1.4 versicolor
#> 93           5.8         2.6          4.0         1.2 versicolor
#> 94           5.0         2.3          3.3         1.0 versicolor
#> 95           5.6         2.7          4.2         1.3 versicolor
#> 96           5.7         3.0          4.2         1.2 versicolor
#> 97           5.7         2.9          4.2         1.3 versicolor
#> 98           6.2         2.9          4.3         1.3 versicolor
#> 99           5.1         2.5          3.0         1.1 versicolor
#> 100          5.7         2.8          4.1         1.3 versicolor
#> 101          6.3         3.3          6.0         2.5  virginica
#> 102          5.8         2.7          5.1         1.9  virginica
#> 103          7.1         3.0          5.9         2.1  virginica
#> 104          6.3         2.9          5.6         1.8  virginica
#> 105          6.5         3.0          5.8         2.2  virginica
#> 106          7.6         3.0          6.6         2.1  virginica
#> 107          4.9         2.5          4.5         1.7  virginica
#> 108          7.3         2.9          6.3         1.8  virginica
#> 109          6.7         2.5          5.8         1.8  virginica
#> 110          7.2         3.6          6.1         2.5  virginica
#> 111          6.5         3.2          5.1         2.0  virginica
#> 112          6.4         2.7          5.3         1.9  virginica
#> 113          6.8         3.0          5.5         2.1  virginica
#> 114          5.7         2.5          5.0         2.0  virginica
#> 115          5.8         2.8          5.1         2.4  virginica
#> 116          6.4         3.2          5.3         2.3  virginica
#> 117          6.5         3.0          5.5         1.8  virginica
#> 118          7.7         3.8          6.7         2.2  virginica
#> 119          7.7         2.6          6.9         2.3  virginica
#> 120          6.0         2.2          5.0         1.5  virginica
#> 121          6.9         3.2          5.7         2.3  virginica
#> 122          5.6         2.8          4.9         2.0  virginica
#> 123          7.7         2.8          6.7         2.0  virginica
#> 124          6.3         2.7          4.9         1.8  virginica
#> 125          6.7         3.3          5.7         2.1  virginica
#> 126          7.2         3.2          6.0         1.8  virginica
#> 127          6.2         2.8          4.8         1.8  virginica
#> 128          6.1         3.0          4.9         1.8  virginica
#> 129          6.4         2.8          5.6         2.1  virginica
#> 130          7.2         3.0          5.8         1.6  virginica
#> 131          7.4         2.8          6.1         1.9  virginica
#> 132          7.9         3.8          6.4         2.0  virginica
#> 133          6.4         2.8          5.6         2.2  virginica
#> 134          6.3         2.8          5.1         1.5  virginica
#> 135          6.1         2.6          5.6         1.4  virginica
#> 136          7.7         3.0          6.1         2.3  virginica
#> 137          6.3         3.4          5.6         2.4  virginica
#> 138          6.4         3.1          5.5         1.8  virginica
#> 139          6.0         3.0          4.8         1.8  virginica
#> 140          6.9         3.1          5.4         2.1  virginica
#> 141          6.7         3.1          5.6         2.4  virginica
#> 142          6.9         3.1          5.1         2.3  virginica
#> 143          5.8         2.7          5.1         1.9  virginica
#> 144          6.8         3.2          5.9         2.3  virginica
#> 145          6.7         3.3          5.7         2.5  virginica
#> 146          6.7         3.0          5.2         2.3  virginica
#> 147          6.3         2.5          5.0         1.9  virginica
#> 148          6.5         3.0          5.2         2.0  virginica
#> 149          6.2         3.4          5.4         2.3  virginica
#> 150          5.9         3.0          5.1         1.8  virginica

autils::check_expr(iris)
#> 
#> 基因表达矩阵全面检查报告
#> ============
#> 
#> 1. 基本信息
#> -------
#> 数据类型: data.frame 
#> 维度: 150 x 5 ( 150 个基因, 5 个样本)
#> 
#> 2. 数据类型和结构检查
#> ------------
#> 检测到行名，假定为基因ID。
#> 检测到列名，假定为样本ID。
#> ------------
#> 基因名检查通过，无重复。
#> 样本名检查通过，无重复。
#> 警告: 存在非数值列。尝试转换为数值型...
#> Warning in autils::check_expr(iris): NAs introduced by coercion
#> 所有列成功转换为数值型。
#> 负值检查通过，无负值。
#> 缺失值总数: 150 
#> 缺失值比例: 20.00% 
#> 警告: 缺失值比例较高。
#> 无全为NA的行。
#> 警告: 存在全为NA的列。
#> [1] "Species"
#> 
#> 3. 数据分布检查
#> ---------
#> 检测到非 counts 矩阵。
#> 数据可能已经过对数转换，无需再次转换。
#> 
#> 样本的均值和中位数:
#>                    Sample     Mean Median
#> Sepal.Length Sepal.Length 5.843333   5.80
#> Sepal.Width   Sepal.Width 3.057333   3.00
#> Petal.Length Petal.Length 3.758000   4.35
#> Petal.Width   Petal.Width 1.199333   1.30
#> Species           Species      NaN     NA
#> 警告: 以下样本的平均表达值显著低于中位数的一半:
#> [1] "Petal.Width" NA           
#> 
#> 4. 缺失值检查
#> --------
#> 每个样本的缺失值数量:
#> Species 
#>     150 
#> 每个基因的缺失值数量:
#>   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#>  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#>  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#>  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#>  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#> 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#> 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 
#>   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1 
#> 141 142 143 144 145 146 147 148 149 150 
#>   1   1   1   1   1   1   1   1   1   1 
#> 
#> 5. 异常值检查
#> --------
#> 使用的阈值: IQR 方法的 1.5 倍
#> 所有样本的异常值比例在正常范围内。
#> 
#> 6. 样本相关性检查
#> ----------
#> 使用的阈值: 相关性 < 0.7
#> 注意: 存在相关性较低的样本对。
#>              row col
#> Sepal.Width    2   1
#> Sepal.Length   1   2
#> Petal.Length   3   2
#> Petal.Width    4   2
#> Sepal.Width    2   3
#> Sepal.Width    2   4
#> 
#> 7. 基因表达水平检查
#> -----------
#> 使用的阈值: 基因平均表达水平 < 1
#> 低表达基因比例在可接受范围内。
#> 不存在零方差基因
#> 8. 批次效应检查
#> ---------
#> 样本数量较少（<=5），无法进行可靠的批次效应检查。
#> 
#> 9. Housekeeping 基因检查
#> --------------------
#> 未提供物种信息，无法进行 housekeeping 基因检查。
#> 
#> 10. 变异系数检查
#> ----------
#> 高变异系数基因比例: 0.00% 
#> 大多数基因的变异系数在正常范围内。
#> 
#> 优化建议
#> ====
#> 1.  考虑对缺失值进行适当处理，如填充、删除或评估其对下游分析的影响。 
#> 2.  检查并可能需要移除全为NA的样本列。 
#> 3.  平均表达水平低的样本可能存在质量问题，需进一步检查。 
#> 4.  存在缺失值的样本可能需要进行处理或移除。 
#> 5.  存在缺失值的基因可能需要进行处理或移除。 
#> 6.  检查相关性较低的样本对，考虑是否存在批次效应或样本异常。 
#> 7.  建议增加样本数量以进行更可靠的批次效应分析。 
#> 8.  提供物种信息以进行 housekeeping 基因检查，可以更全面地评估数据质量。 
#> 
#>  检查报告生成完毕
```
