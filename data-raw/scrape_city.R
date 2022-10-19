## code to prepare `scrape_city` dataset goes here

# ==== Proc 1: raw data scrape process ====

# step 0: prepare
source("data-raw/load-pkg.R", encoding = "UTF-8")

data("zone_province")

# step 1: get city

url_head <- "http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2021/"
tbl_city <- zone_province %>%
  mutate(url = str_c(url_head, pid, ".html") ) %>%
  mutate(dt = map(.x = url, .f = get.tbl, len=4)) %>%
  unnest(dt)

out_path <- "data-raw/data-sql/zone2-city.rds"
write_rds(tbl_city, out_path)


#==== Proc 2: pgd data set ====

file_path <- "data-raw/data-sql/zone2-city.rds"
zone_city <- readRDS(file_path)

# write out data set
usethis::use_data(zone_city, overwrite = TRUE)

# write r file
use_r("zone_city")

# my helper function
document_dt(zone_city)

# formally document
document()
