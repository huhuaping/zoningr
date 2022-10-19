## code to prepare `scrape_district` dataset goes here

# ==== Proc 1: raw data scrape process ====

# step 0: prepare
source("data-raw/load-pkg.R", encoding = "UTF-8")

data("zone_city")
tbl_city <- zone_city

# step 3: get street
K <- 10
tot <- nrow(tbl_city)
page <- ceiling(tot/K)

tbl_out <- NULL
for (j in 1:page) {
  cat(glue("begin page {j}..."), sep = "\n")
  blocks <- ((j-1)*K):(j*K)
  rows <- blocks[-1]
  tbl_tem <- tbl_city  %>%
    .[rows,] %>%
    mutate(
      url = str_replace(
        url, pattern = "\\.html",
        replacement = str_c("/",cid,".html"))
    ) %>%
    filter(!is.na(province)) %>%
    mutate(dt = map(.x = url, .f = get.tbl, len=6) ) %>%
    unnest(dt)
  tbl_out <- bind_rows(tbl_out, tbl_tem)
  cat(glue("---end page {j}"), sep = "\n")
}

out_path <- "data-raw/data-sql/zone3-district.rds"
write_rds(tbl_out, out_path)

# ===== Proc 2: pgk data set construction=====

# read file
file_path <- "data-raw/data-sql/zone3-district.rds"
zone_district <- readRDS(file_path)

# write out data set
usethis::use_data(zone_district, overwrite = TRUE)

# write r file
use_r("zone_district")

# my helper function
document_dt(zone_district)

# formally document
document()
