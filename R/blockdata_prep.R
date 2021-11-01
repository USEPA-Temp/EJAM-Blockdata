blockdata_prep <- function(blockdatalocation='blockdata.rdata') {

  # This was to clean up the Census 2020 block data to be ready for use in the fast buffering code
# but this should actually just be done as part of the package-
  # and the result should be saved as data for this package
  # instead of calling this as a function everytime the app is used

  # the 2020 block dataset census2020download::blocks2020 in progress has different colnames, like lat lon pop
  # instead of INTPTLAT INTPTLON POP100
  # and not all these cols like STATE,COUNTY,TRACT,BLKGRP that are subparts of fipsblock
  # env <- globalenv()      # it used to put this in env as env$blockdata   The global environment .GlobalEnv, more often known as the user's workspace, is the first item on the search path. It can also be accessed by globalenv(). On the search path, each item's enclosure is the next item.

  ########### LOAD BLOCKDATA ###########

  # if ( !fromfile ) {
  #   mdb <- DBI::dbConnect(RMySQL::MySQL(), host=server, user=user, password=password, dbname=schema) # were defined in initialization script
  #   sql.query <- paste("SELECT STUSAB, STATE, COUNTY, TRACT, BLKGRP, BLOCK, POP100, HU100, INTPTLAT, INTPTLON  FROM ejscreen.geoblocks;")
  #   blockdata <- data.table::as.data.table(DBI::dbGetQuery(mdb, sql.query))
  #   #saverds(blockdata,blockdatalocation)
  # } else {
    blockdata <- readRDS(blockdatalocation)
  # }
    # drop if zero population
  blockdata <- blockdata[POP100 != 0,]  # this syntax of [POP100 != 0, ] would not work on a data.frame but works on a data.table, right?

  ########### convert blockdata lat lon to XYZ units ###########

  blockdata[,"BLOCK_LAT_RAD"] <- blockdata$INTPTLAT * pi / 180
  blockdata[,"BLOCK_LONG_RAD"] <- blockdata$INTPTLON * pi / 180
  blockdata[,"BLOCK_X"] <- earthRadius_miles * cos(blockdata$BLOCK_LAT_RAD) * cos(blockdata$BLOCK_LONG_RAD)
  blockdata[,"BLOCK_Y"] <- earthRadius_miles * cos(blockdata$BLOCK_LAT_RAD) * sin(blockdata$BLOCK_LONG_RAD)
  blockdata[,"BLOCK_Z"] <- earthRadius_miles * sin(blockdata$BLOCK_LAT_RAD)

  ########### Create grid, like 10 mile grid indices - ***** BUT CHECK IF THIS IS ACTUALLY NEEDED - ******** is it used at all? dont see where ###########

  blockdata[,"GRID_X"] <- as.integer(round(blockdata$BLOCK_X/indexgridsize))
  blockdata[,"GRID_Y"] <- as.integer(round(blockdata$BLOCK_Y/indexgridsize))
  blockdata[,"GRID_Z"] <- as.integer(round(blockdata$BLOCK_Z/indexgridsize))
  blockdata$ID <- 1:nrow(blockdata)

  ########### add blockgroup FIPS in blockdata ###########

  # for merging blockgroup indicators to buffered blocks later on
  blockdata <- cbind(do.call(paste0, blockdata[,.(STATE,COUNTY,TRACT,BLKGRP)]),blockdata)  # # this syntax would not work on a data.frame but works on a data.table, right?
  names(blockdata)[names(blockdata)=="V1"] <- "BLOCKGROUPFIPS"

  ########### count total pop, for each block, of its parent blockgroup ###########

  # Calculated later in doaggregate(), the scoringweight = fraction of whole Blockgroup pop that is in a given block.
  # That scoringweight is used for pop weighting the blockgroup indicator scores for all blocks in the buffer.
  popsums <- blockdata[,sum(as.numeric(POP100)),by="BLOCKGROUPFIPS"] # this syntax of [POP100 != 0, ] would not work on a data.frame but works on a data.table, right?
  names(popsums)[names(popsums)=="V1"] <- "Census2010Totalpop"
  data.table::setkey(blockdata,"BLOCKGROUPFIPS")
  data.table::setkey(popsums,"BLOCKGROUPFIPS")
  blockdata <- merge(blockdata,popsums)

  ########### create unique BLOCKID for blockdata ###########

  blockdata <- cbind(do.call(paste0, blockdata[,.(STATE,COUNTY,TRACT,BLKGRP,BLOCK)]), blockdata)
  names(blockdata)[names(blockdata)=="V1"] <- "BLOCKID"
  data.table::setkey(blockdata, "GRID_X","GRID_Y","GRID_Z")  # IS THIS REALLY USED LATER SOMEWHERE??? does it somehow speed up queries of blockdata for finding all within radius miles of a facility point?
  return(blockdata)
  # blockdata <- blockdata_prep(blockdatalocation = 'blockdata.rdata')
}

