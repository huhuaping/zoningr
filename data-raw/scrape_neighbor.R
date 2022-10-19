## code to prepare `scrape_neighbor` dataset goes here

# ==== Proc 1: raw data scrape process ====

# step 0: prepare
source("data-raw/load-pkg.R", encoding = "UTF-8")

data("zone_street")
tbl_street <- zone_street


# step 3: get neighbor
K <- 50
tot <- nrow(tbl_street)
page <- ceiling(tot/K)

require(logr)
path_log <- "data-raw/data-sql/neighbor.log"
logr::log_open(path_log)

tbl_out <- NULL
# loop
i <- 1
for (i in 1:page){

  inf_out <- glue("begin page {i}...")
  log_print(inf_out)

  blocks <- ((i-1)*K):(i*K)
  rows <- blocks[-1]

  cat(glue("fretch page {i} with min {min(rows)}, and max {max(rows)}"), sep = "\n")
  # get neighbor
  tbl_tem <- tbl_street %>%
    .[rows,] %>%
    filter(!is.na(province)) %>%
    # the path change here
    mutate(
      sid_short = str_extract(sid,"(\\d{3})$"),
      url = str_replace(
        url, pattern = "(\\d{4})(?=\\d{2}\\.html)",
        replacement = "")
    ) %>%
    #filter(cid =="1301") %>%
    mutate(
      url = str_replace(
        url, pattern = "\\.html",
        replacement = str_c("/",sid,".html"))
    ) %>%
    #head() %>%
    mutate(dt = map(.x = url, .f = get.tbl, len=12) ) %>%
    unnest(dt)

  tbl_out <- bind_rows(tbl_out, tbl_tem)
  inf_out <- glue("---end page {i}")
  log_print(inf_out)
}

# write data raw
out_path <- "data-raw/data-sql/zone5-neighbor.rds"
write_rds(tbl_out, out_path)
## the file size is larger than 50M,
## thus you should compress the data
saveRDS(tbl_out, out_path, compress = T)

# ===== Proc 2: pgk data set construction=====

# read file
file_path <- "data-raw/data-sql/zone5-neighbor.rds"
zone_neighbor <- readRDS(file_path)


# write out data set
usethis::use_data(zone_neighbor, overwrite = TRUE)

# write r file
use_r("zone_neighbor")

# my helper function
document_dt(zone_neighbor)

# formally document
document()
