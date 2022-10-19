## code to prepare `scrape_parallel` dataset goes here

# ====step 0: prepare====
source("data-raw/load-pkg.R", encoding = "UTF-8")

data("zone_city")
tbl_city <- zone_city


# ====step 2 : get district with  parallel method====

require(parallel)
detectCores()
cl <- makeCluster(4)

clusterEvalQ(cl, {
  require(magrittr)
  require(tidyverse)
  require(rvest)
  require(httr)
  require(glue)
  require(stringr)
})

clusterExport(cl, "tbl_city")
clusterExport(cl, "get.tbl")

get_par <- function(i, dt = tbl_city){

  K <- 10
  tot <- nrow(dt)
  page <- ceiling(tot/K)

  blocks <- ((i-1)*K):(i*K)
  rows <- blocks[-1]

  cat(glue::glue("fretch page {i} with min {min(rows)}, and max {max(rows)}"), sep = "\n")

  tbl_out <- dt  %>%
    .[rows,] %>%
    mutate(
      url = str_replace(
        url, pattern = "\\.html",
        replacement = str_c("/",cid,".html"))
    ) %>%
    mutate(dt = map(.x = url, .f = get.tbl, len=6) ) %>%
    unnest(dt)
  return(tbl_out)
}

K <- 10
tot <- nrow(tbl_city)
page <- ceiling(tot/K)

# now run parallel computing
## note: this process will be failed
## if your internet is lows peed or not stable.

s <- parLapply(cl, 1:page, get_par)

check <- s[[1]]

