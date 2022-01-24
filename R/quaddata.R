#' @name quaddata
#' @docType data
#' @title quad tree data on locations of US blocks (6,246,672 in the Census 2010-based data here)
#' 
#' @description This is just selected columns from block dataset
#' \preformatted{
#' 
#'   # 2016 code that created blockdata, quaddata, blockquadtree, and localtree:
#'   blockdata <- 0
#'   quaddata <- blockdata[ , .(BLOCK_X, BLOCK_Z, BLOCK_Y, BLOCKID)]
#'   blockquadtree <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point")
#'   localtree     <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point")
#'   }
#'   
#' \preformatted{
#'   
#' 2010 data:
#' Classes ‘data.table’ and 'data.frame':	6246672 obs. of  4 variables:
#' $ BLOCK_X: num  -2442 -2440 -2440 -2439 -2440 ...
#' $ BLOCK_Z: num  3112 3115 3114 3115 3114 ...
#' $ BLOCK_Y: num  -144 -144 -144 -144 -143 ...
#' $ BLOCKID: chr  "0201600010011250" "0201600010011270" "0201600010011291" "0201600010011297" ...
#' }
#' 
#'   \preformatted{
#'
#'  localtree seemed to be a duplicate of that blockquadtree data 
#'  
#'    And tried
#'     saveRDS(localtree, file = './data/localtree.rda')
#'    since 
#'  BUILDING THIS localtree TAKES MAYBE 30 SECONDS, 
#'  so it should be done when creating package and saved as data like quaddata
#'  But there is a problem doing that- localtree.rda has magic number 'X'
#'   Use of save vesions prior to 2 is deprecated. 
#'   So it can get created on launch for now. 
#'     
#'   }
NULL
