
#' Help Document the Variables List of Data Set for Package Development
#'
#' @param df a data frame
#'
#' @export document_dt
#'
#' @examples
#' data(zone_province)
#' document_dt(zone_province)
#'
#'
document_dt <- function(df){
  cat(
    "#' ",
    "#' ",
    "#' @format ",
    "#' \\describe{",

    paste0("#'   \\item{",names(df),"}{  }"),
    "#' }",
    sep="\n")
}

