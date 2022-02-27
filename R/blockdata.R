#' @name blockdata
#' @docType data
#' @title 2010 US Census blocks (locations and FIPS)
#' 
#' @description
#'   \preformatted{
#'    
#' #   > tables()
#' #            NAME      NROW NCOL    MB  COLS                                                        KEY
#' # 1:    blockdata 6,246,672   17 1,181 blockfips,bgfips,STUSAB,blockpop2010,INTPTLAT,INTPTLON,...  blockfips,bgfips
#' #
#' #    > round(file.info(list.files())[,1,drop=F]/1e6,1)
#' #               approx MB file size
#' # blockdata.rdata   363.7  ** Will be dropped - do not need this large file
#' 
#'   > str((blockdata))  # but this will be replaced by a few smaller files.
#'   # 
#'  Classes ‘data.table’ and 'data.frame':	6246672 obs. of  17 variables:
#'  $ blockfips     : chr  "0100102010011000" "0100102010011003" "0100102010011005" "0100102010011007" ...
#'  $ bgfips        : chr  "010010201001" "010010201001" "010010201001" "010010201001" ...
#'  $ STUSAB        : chr  "AL" "AL" "AL" "AL" ...
#'  $ blockpop2010  : int  61 75 1 23 1 2 2 70 56 26 ...
#'  $ INTPTLAT      : num  32.5 32.5 32.5 32.5 32.5 ...
#'  $ INTPTLON      : num  -86.5 -86.5 -86.5 -86.5 -86.5 ...
#'  $ BLOCK_LAT_RAD : num  0.567 0.567 0.567 0.567 0.567 ...
#'  $ BLOCK_LONG_RAD: num  -1.51 -1.51 -1.51 -1.51 -1.51 ...
#'  $ BLOCK_X       : num  205 205 205 204 204 ...
#'  $ BLOCK_Y       : num  -3334 -3334 -3334 -3334 -3334 ...
#'  $ BLOCK_Z       : num  2125 2125 2125 2126 2126 ...
#'  $ ID            : int  1 2 3 4 5 6 7 8 9 10 ...
#'  $ GRID_X        : int  21 20 20 20 20 20 20 21 21 21 ...
#'  $ GRID_Y        : int  -333 -333 -333 -333 -333 -333 -333 -333 -333 -333 ...
#'  $ GRID_Z        : int  213 213 213 213 213 213 213 213 213 213 ...
#'  $ bgpop2010     : num  698 698 698 698 698 698 698 698 698 698 ...
#'  $ blockwt       : num  0.08739 0.10745 0.00143 0.03295 0.00143 ...
#'   - attr(*, ".internal.selfref")=<externalptr> 
#'   - attr(*, "sorted")= chr [1:2] "blockfips" "bgfips"
#'   
#'   
#'  ###### 2016 version was even bigger and had these columns:  #####
#'   
#' [1,] "blockid"        # 16-character block FIPS (or is it 15?)
#' [2,] "BLOCKGROUPFIPS" # 12-character FIPS of blockgroup this block is part of
#' 
#' [3,] "STUSAB" # 2-character State abbreviation
#' [4,] "STATE"  # 2-character State part of FIPS
#' [5,] "COUNTY" # 3-character County part of FIPS
#' [6,] "TRACT"  # 6-character Tract part of FIPS
#' [7,] "BLKGRP" # 1-character blockgroup part of FIPS
#' [8,] "BLOCK"  # 4-character block part of FIPS
#' 
#' [9,] "POP100"  # Population count of block, from Decennial Census
#' [10,] "HU100"  # Housing units count
#' 
#' [11,] "INTPTLAT"  #  latitude in decimal degrees
#' [12,] "INTPTLON"  #  longitude in decimal degrees
#' [13,] "BLOCK_LAT_RAD" # in radians
#' [14,] "BLOCK_LONG_RAD" # in radians
#' [15,] "BLOCK_X"  # for the quadtree
#' [16,] "BLOCK_Y"  # for the quadtree
#' [17,] "BLOCK_Z"  # for the quadtree
#' 
#' [18,] "ID"   #   a unique ID for the Census blocks (same as blockid)

#' [19,] "GRID_X" # not sure it is needed
#' [20,] "GRID_Y" # not sure it is needed
#' [21,] "GRID_Z" # not sure it is needed
#' 
#' [22,] "Census2010Totalpop" # population of blockgroup this block is part of
#'   }
NULL
