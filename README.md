
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zoningr包

<!-- badges: start -->
<!-- badges: end -->

`zoningr`包主要是实现对中国城乡区划的统计编码数据实现抓取，并提供抓取后的各层级数据集（地市级city、区县级district、乡镇街道级street和村组居委会级neighbor）。

## Installation安装

You can install the released version of `zoningr` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("huhuaping/zoningr")
```

## Example示例

This is a basic example which shows you how to solve a common problem:

``` r
library(zoningr)
## basic example code

data("zone_street")
head(zone_street)
#> # A tibble: 6 × 10
#>   province pid   url               cid   cname did   dname cid_short sid   sname
#>   <chr>    <chr> <chr>             <chr> <chr> <chr> <chr> <chr>     <chr> <chr>
#> 1 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 东华…
#> 2 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 景山…
#> 3 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 交道…
#> 4 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 安定…
#> 5 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 北新…
#> 6 北京     11    http://www.stats… 1101  市辖… 1101… 东城… 01        1101… 东四…
```

## 数据来源

数据集抓取自中国统计局官网
统计用区划和城乡划分代码（2021年）：[链接](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/)。

## 抓取策略

网页分析：

-   开放查询和下载，少有拒绝访问的情形

-   目标文本以html `<table></table>`形式呈现，可以方便地抓取为表格

-   目标页面的`url`地址根据区划代码，呈现很好的规律性

抓取方法：

-   基于`R`工具进行抓取（`httr`和`rvest`包等）

-   分层级抓取，包括：地市级city、区县级district、乡镇街道级street和村组居委会级neighbor。

-   开发了统一的表格抓取函数，例如`get.tbl(url = url_tar, len = 4)`

-   最后两层级的数据量比较大，也可以考虑使用并行计算方法进行抓取。

``` r
library(zoningr)
data("zone_street")
data("zone_neighbor")
n4 <- nrow(zone_street)
n5 <- nrow(zone_neighbor)

print(c(n4,n5))
#> [1]  41636 633806
```
