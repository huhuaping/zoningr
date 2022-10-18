## code to prepare `get_table` dataset goes here
#' Title
#'
#' @param url character.
#' @param len integer. short coding digits.
#' @import dplyr
#' @import glue
#' @import httr
#' @import rvest
#' @import stringr
#' @importFrom tibble as_tibble
#' @importFrom magrittr %>%
#'
#' @return data.frame
#' @export get.tbl
#'
#' @examples
#' url_tar  <- "http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2021/13/03/22/130322102.html"
#' l <- 12
#' out <- get.tbl(url = url_tar, len= l)

get.tbl <- function(url, len){

  # specify lead character
  if (len == 4){
    lead <- "c"  # city
  } else if (len == 6){
    lead <- "d"  # district
  } else if (len == 9){
    lead <- "s"  # street
  } else if (len == 12){
    lead <- "n"  # neighbor
  }

  # specify column names
  if (len ==12){
    # case for the last level: neighbor
    name_chn <- c("统计","城乡分类","名称")
    name_list <- paste0(lead, c("id","ur","name"))
    focus_col <- 3
  } else {
    # case for other levels
    name_chn <- c("统计","名称")
    name_list <- paste0(lead, c("id","name"))
    focus_col <- 2
  }

  # access the webpage url with maximum three times,
  # avoid internet timeout
  for (m in 1:3){
    get <- url %>%
      httr::GET(., httr::timeout(20))
    #get <- httr::RETRY("GET", url, times =5)

    stat_code <- get$status_code
    Sys.sleep(0.1)
    cat(glue("access try {m}"), sep = "\n")
    if (stat_code==200L) break()
  }

  ## city-itself has no valid href url
  ## 例如石家庄市>市辖区
  if (stat_code == 404L) {
    out <- matrix(
      rep("", length(name_chn)),
      byrow = T,nrow = 1
    ) %>%
      as_tibble(.,.name_repair = "unique") %>%
      rename_all(., ~name_list)

    # case exist valid href url
  } else if (stat_code == 200L){
    out <- get %>%
      rvest::read_html() %>%
      rvest::html_table(., header = T) %>%
      .[[5]] %>%
      as_tibble() %>%
      dplyr::mutate_all(., as.character) %>%
      dplyr::rename_all(., ~name_list) %>%
      dplyr::mutate_at(
        dplyr::vars(dplyr::ends_with("id")),
        ~ str_extract(.x, paste0("^\\d{",len,"}")
        )
      )

  } # end case

  # print information
  id_tar <- unique(unlist(out[,1]))
  id_max <- max(id_tar)
  # focus column we are interesting
  name_max <- unlist(out[,focus_col])[which(id_tar==id_max)]
  cat(glue("latest id is {id_max} with name {name_max}"),
      sep ="\n")
  return(out)
}
