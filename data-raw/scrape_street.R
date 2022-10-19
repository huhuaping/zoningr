## code to prepare `scrape_street` dataset goes here

# ==== Proc 1: raw data scrape process ====

# step 0: prepare
source("data-raw/load-pkg.R", encoding = "UTF-8")

data("zone_district")
tbl_district <- zone_district

# step 3: get street
K <- 10
tot <- nrow(tbl_district)
page <- ceiling(tot/K)

require(logr)
path_log <- "data-raw/data-sql/district.log"
logr::log_open(path_log)

tbl_out <- NULL
# loop
for (i in 1:1){

  inf_out <- glue("begin page {i}...")
  log_print(inf_out)

  blocks <- ((i-1)*K):(i*K)
  rows <- blocks[-1]

  cat(glue("fretch page {i} with min {min(rows)}, and max {max(rows)}"), sep = "\n")
  # get street
  tbl_tem <- tbl_district %>%
    .[rows,] %>%
    filter(!is.na(province)) %>%
    # the path change here
    mutate(
      cid_short = str_extract(cid,"\\d{2}$"),
      url = str_replace(
        url, pattern = "(\\d{4})(?=\\.html)",
        replacement = cid_short)
    ) %>%
    #filter(cid =="1301") %>%
    mutate(
      url = str_replace(
        url, pattern = "\\.html",
        replacement = str_c("/",did,".html"))
    ) %>%
    #head() %>%
    mutate(dt = map(.x = url, .f = get.tbl, len=9) ) %>%
    unnest(dt)

  tbl_out <- bind_rows(tbl_out, tbl_tem)
  inf_out <- glue("---end page {i}")
  log_print(inf_out)
}

# write data raw
out_path <- "data-raw/data-sql/zone4-street.rds"
write_rds(tbl_out, out_path)

# ===== Proc 2: pgk data set construction=====

# read file
file_path <- "data-raw/data-sql/zone4-street.rds"
zone_street <- readRDS(file_path)


# write out data set
usethis::use_data(zone_street, overwrite = TRUE)

# write r file
use_r("zone_street")

# my helper function
document_dt(zone_street)

# formally document
document()
