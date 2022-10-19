## code to prepare `read_province` dataset goes here

file_path <- "data-raw/data-sql/zone1-province.txt"
zone_province <- read.delim(file_path,sep = " ")

# write out data set
usethis::use_data(zone_province, overwrite = TRUE)

# write r file
use_r("zone_province")

# my helper function
document_dt(zone_province)

# formally document
document()
