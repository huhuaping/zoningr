#' neighbor zoning (level 5)
#'
#' @format data.frame
#' \describe{
#'   \item{province}{ character }
#'   \item{pid}{ character, province zoning id with 2 digits}
#'   \item{url}{ character }
#'   \item{cid}{ character, city zoning id with 4 digits  }
#'   \item{cname}{ character, name of city}
#'   \item{did}{ character, district zoning id with 6 digits   }
#'   \item{dname}{ character, name of district }
#'   \item{cid_short}{ character, short city zoning id with 2 digits  }
#'   \item{sid}{ character, street zoning id with 9 digits  }
#'   \item{sname}{ character, name of street }
#'   \item{sid_short}{  character, short street zoning id with 3 digits   }
#'   \item{nid}{ character, neighbor zoning id with 12 digits   }
#'   \item{nur}{ character, uban and rural zoning type with 3 digits   }
#'   \item{nname}{ character, name of neighbor }
#' }

"zone_neighbor"
