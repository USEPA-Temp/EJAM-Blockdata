#' @docType package
#' @name blockdata
#' @aliases blockdata-package
#' 
#'   @details  
#' @md  
#' 
#'   This package provides Census 2010 block data for use in the EJAM package.
#'   Census 2010 dataset was obtained in 2016, reformatted here in 2021-2022.
#'   Census 2020 dataset was obtained in 2021, see census2020download package.
#'   ############################################################## #
#'   
#'   @details # Format to be used starting 2/22/2022, for Census 2010 and 2020 datasets:
#'   
#'   ############################################################## #
#'   
#'   @details ## **The Census 2010 data** 
#'  
#'     > tables()
#'                NAME      NROW NCOL    MB  COLS                                                        KEY
#'   2: *blockid2fips* 6,246,672    2   548 blockid,blockfips    KEY = blockid,blockfips
#'   3:  *blockpoints* 6,246,672    3   119 blockid,lat,lon      KEY = blockid,lat,lon
#'   4:     *blockwts* 6,246,672    3   132 blockid,bgfips,blockwt  KEY = blockid,bgfips
#'   5:     *quaddata* 6,246,672    4   167 BLOCK_X,BLOCK_Z,BLOCK_Y,blockid  KEY = blockid,BLOCK_X,BLOCK_Y,BLOCK_Z
#'  
#'     > filesizeinfo <- round(file.info(list.files(path = './data/',full.names = TRUE))[,1,drop=F]/1e6,0)
#'     > filesizeinfo[order(filesizeinfo$size,decreasing = T),,drop=F]
#'                 
#'                  approx MB file size
#'      *quaddata.rda*  141
#'   *blockpoints.rda*   69   ** actually not essential, but keep just in case. this just has lat lon, but seems big. 
#'      *blockwts.rda*   30
#'  *blockid2fips.rda*   17 ** this is huge in RAM, but small on disk
#' *blockquadtree.rda*    0
#' 
#'   >    head(blockid2fips,2); str(blockid2fips)
#'      blockid        blockfips
#'   1:       1 0100102010011000
#'   2:       2 0100102010011003
#'   Classes ‘data.table’ and 'data.frame':	6246672 obs. of  2 variables:
#'   $ blockid  : int  1 2 3 4 5 6 7 8 9 10 ...
#'   $ blockfips: chr  "0100102010011000" "0100102010011003" "0100102010011005" "0100102010011007" ...
#'     - attr(*, ".internal.selfref")=<externalptr>
#'     - attr(*, "sorted")= chr [1:2] "blockid" "blockfips"
#'     - attr(*, "year")= num 2010
#' 
#'   >    head(quaddata,2); str(quaddata)
#'       BLOCK_X  BLOCK_Z   BLOCK_Y blockid
#'   1: 205.0169 2125.402 -3333.814       1
#'   2: 204.5543 2125.367 -3333.864       2
#'   Classes ‘data.table’ and 'data.frame':	6246672 obs. of  4 variables:
#'   $ BLOCK_X: num  205 205 205 204 204 ...
#'   $ BLOCK_Z: num  2125 2125 2125 2126 2126 ...
#'   $ BLOCK_Y: num  -3334 -3334 -3334 -3334 -3334 ...
#'   $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
#'     - attr(*, ".internal.selfref")=<externalptr>
#'     - attr(*, "year")= num 2010
#' 
#'   >    str(blockquadtree,2)
#'   Formal class 'QuadTree' [package "SearchTrees"] with 7 slots
#'   ..@ ref      :<externalptr>
#'   ..@ numNodes : int 6281
#'   ..@ dataNodes: int 4043
#'   ..@ maxDepth : int 7
#'   ..@ maxBucket: int 50030
#'   ..@ totalData: int 6246672
#'   ..@ dataType : chr "point"
#'   ..$ data  :<externalptr>
#'   ..$ points: int 6246672
#'   ..$ year  : num 2010
#' 
#'   >    head(blockwts,2); str(blockwts)
#'      blockid       bgfips    blockwt
#'   1:       1 010010201001 0.08739255
#'   2:       2 010010201001 0.10744986
#'   Classes ‘data.table’ and 'data.frame':	6246672 obs. of  3 variables:
#'   $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
#'   $ bgfips : chr  "010010201001" "010010201001" "010010201001" "010010201001" ...
#'   $ blockwt: num  0.08739 0.10745 0.00143 0.03295 0.00143 ...
#'    - attr(*, ".internal.selfref")=<externalptr>
#'    - attr(*, "sorted")= chr [1:2] "blockid" "bgfips"
#'    - attr(*, "year")= num 2010
#' 
#'   >    head(blockpoints,2); str(blockpoints)
#'      blockid      lat       lon
#'   1:       1 32.46968 -86.48096
#'   2:       2 32.46909 -86.48893
#'   Classes ‘data.table’ and 'data.frame':	6246672 obs. of  3 variables:
#'   $ blockid: int  1 2 3 4 5 6 7 8 9 10 ...
#'   $ lat    : num  32.5 32.5 32.5 32.5 32.5 ...
#'   $ lon    : num  -86.5 -86.5 -86.5 -86.5 -86.5 ...
#'    - attr(*, ".internal.selfref")=<externalptr>
#'    - attr(*, "sorted")= chr [1:3] "blockid" "lat" "lon"
#'    - attr(*, "year")= num 2010
#' 
#'  ############################################################# #
#'  ### OLD FILE NO LONGER USED HERE: 
#'   > str((blockdata))  # but this was replaced by a few smaller files.
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
#'   @details ## **2016 version was even bigger**  #######
#'   
#'  [1,] "BLOCKID"        # 16-character block FIPS (or is it 15?)
#'  [2,] "BLOCKGROUPFIPS" # 12-character FIPS of blockgroup this block is part of
#'  
#'  [3,] "STUSAB" # 2-character State abbreviation
#'  [4,] "STATE"  # 2-character State part of FIPS
#'  [5,] "COUNTY" # 3-character County part of FIPS
#'  [6,] "TRACT"  # 6-character Tract part of FIPS
#'  [7,] "BLKGRP" # 1-character blockgroup part of FIPS
#'  [8,] "BLOCK"  # 4-character block part of FIPS
#'  
#'  [9,] "POP100"  # Population count of block, from Decennial Census
#'  [10,] "HU100"  # Housing units count
#'  
#'  [11,] "INTPTLAT"  #  latitude in decimal degrees
#'  [12,] "INTPTLON"  #  longitude in decimal degrees
#'  [13,] "BLOCK_LAT_RAD" # in radians
#'  [14,] "BLOCK_LONG_RAD" # in radians
#'  [15,] "BLOCK_X"  # for the quadtree
#'  [16,] "BLOCK_Y"  # for the quadtree
#'  [17,] "BLOCK_Z"  # for the quadtree
#'  
#'  [18,] "ID"   #   a unique ID for the Census blocks (simpler key than FIPS?) 
#'  [19,] "GRID_X" # not sure it is needed
#'  [20,] "GRID_Y" # not sure it is needed
#'  [21,] "GRID_Z" # not sure it is needed
#'  
#'  [22,] "Census2010Totalpop" # population of blockgroup this block is part of
#'   ###################################### #  
#'
#'   
#'   @keywords internal
"_PACKAGE"
# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
