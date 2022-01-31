blockdata_prep <- function(blockdatalocation='blockdata.rdata') {

  
  # This was used to clean up the 2010 Census block data to be ready for use in the fast buffering code
  
  
  # but this should actually just be done as part of the creating the package-
  # and the result should be saved as data for this package
  # instead of calling this as a function everytime the app is used

  # The 2020 block dataset census2020download::blocks2020 in progress has different colnames, like lat lon pop
  # instead of INTPTLAT INTPTLON POP100
  # and not all these cols like STATE,COUNTY,TRACT,BLKGRP that are subparts of blockfips
  # env <- globalenv()      # it used to put this in env as env$blockdata   The global environment .GlobalEnv, more often known as the user's workspace, is the first item on the search path. It can also be accessed by globalenv(). On the search path, each item's enclosure is the next item.

  ########### LOAD BLOCKDATA ###########
  #
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
  earthRadius_miles <- 3959 # in case it is not already in global envt
  radians_per_degree <- pi / 180
  
  blockdata[,"BLOCK_LAT_RAD"]  <- blockdata$INTPTLAT * radians_per_degree
  blockdata[,"BLOCK_LONG_RAD"] <- blockdata$INTPTLON * radians_per_degree
  coslat <- cos(blockdata$BLOCK_LAT_RAD)
  blockdata[,"BLOCK_X"] <- earthRadius_miles * coslat * cos(blockdata$BLOCK_LONG_RAD)
  blockdata[,"BLOCK_Y"] <- earthRadius_miles * coslat * sin(blockdata$BLOCK_LONG_RAD)
  blockdata[,"BLOCK_Z"] <- earthRadius_miles * sin(blockdata$BLOCK_LAT_RAD)

  ########### Create grid, like 10 mile grid indices - ***** BUT CHECK IF THIS IS ACTUALLY NEEDED - ******** is it used at all? dont see where ###########
  #
  blockdata[,"GRID_X"] <- as.integer(round(blockdata$BLOCK_X/indexgridsize))
  blockdata[,"GRID_Y"] <- as.integer(round(blockdata$BLOCK_Y/indexgridsize))
  blockdata[,"GRID_Z"] <- as.integer(round(blockdata$BLOCK_Z/indexgridsize))
  blockdata$ID <- seq_along(blockdata[ , 1])

  ########### add blockGROUP FIPS in blockdata ###########
  #
  # for merging blockgroup indicators to buffered blocks later on
  blockdata <- cbind(do.call(paste0, blockdata[ , .(STATE,COUNTY,TRACT,BLKGRP)]), blockdata)  # # this syntax would not work on a data.frame but works on a data.table, right?
  names(blockdata)[names(blockdata)=="V1"] <- "BLOCKGROUPFIPS"

  ########### count total pop, for each block, of its parent blockgroup ###########
  #
  # used to be Calculated later in doaggregate(), but here now
  # scoringweight = fraction of whole Blockgroup pop that is in a given block.
  # That scoringweight is used for pop weighting the blockgroup indicator scores for all blocks in the buffer.
  # BUT SEE EJAM blockwts etc.
  popsums <- blockdata[ , sum(as.numeric(POP100)), by="BLOCKGROUPFIPS"] # this syntax of [POP100 != 0, ] would not work on a data.frame but works on a data.table, right?
  names(popsums)[names(popsums) == "V1"] <- "Census2010Totalpop"
  data.table::setkey(blockdata, "BLOCKGROUPFIPS")
  data.table::setkey(popsums,   "BLOCKGROUPFIPS")
  blockdata <- merge(blockdata, popsums)
  

  ########### create unique BLOCKID for blockdata ###########

  blockdata <- cbind(do.call(paste0, blockdata[,.(STATE,COUNTY,TRACT,BLKGRP,BLOCK)]), blockdata)
  names(blockdata)[names(blockdata)=="V1"] <- "BLOCKID"
  
  # as of 1/2022:
  # tables()
  #         NAME      NROW NCOL      MB                                                       COLS              KEY
  # 1:  blockdata 6,246,672   17  1,181 blockfips,bgfips,STUSAB,blockpop2010,INTPTLAT,INTPTLON,... blockfips,bgfips
  #
  # names(blockdata)
  # [1] "blockfips"      "bgfips"         "STUSAB"         "blockpop2010"   "INTPTLAT"       "INTPTLON"       "BLOCK_LAT_RAD" 
  # [8] "BLOCK_LONG_RAD" "BLOCK_X"        "BLOCK_Y"        "BLOCK_Z"        "ID"             "GRID_X"         "GRID_Y"        
  # [15] "GRID_Z"         "bgpop2010"      "blockwt"       
  
  # it was even bigger before some columns renamed or dropped:
  # for the 2010 block data, this ends up as a 335 MB file on disk and 
  # 1.4 GIG in RAM uncompressed. It does not need to be that big.
  # blockdata <- blockdata_prep(blockdatalocation = 'blockdata.rdata')
  # > data.table::tables()
  #         NAME      NROW NCOL     MB                                                 COLS                  KEY
  # 1: blockdata 6,246,672   22  1,397  BLOCKID,BLOCKGROUPFIPS,STUSAB,STATE,COUNTY,TRACT,... GRID_X,GRID_Y,GRID_Z
  # Total: 1,397MB
  # 
  
  ####################### DECIDED TO DROP MOST COLUMNS - SAVE RAM AND DISK SPACE AND NOT NEEDED ANYWAY
  
  blockdata[ , c('STATE', 'COUNTY', 'TRACT', 'BLKGRP', 'BLOCK', 'HU100') := NULL]
  data.table::setnames(blockdata, 'Census2010Totalpop', 'bgpop2010')
  data.table::setnames(blockdata, 'BLOCKID', 'blockfips')
  data.table::setnames(blockdata, 'BLOCKGROUPFIPS', 'bgfips')
  data.table::setnames(blockdata, 'POP100', 'blockpop2010')
  blockdata[ , blockwt := blockpop2010 / bgpop2010] # the ones with zero population were already removed
  # # maybe can drop more here, like bgpop2010 and blockpop2010... only need the weights actually?
  # blockdata[ , c('blockpop2010', 'bgpop2010') := NULL]
  
  # data.table::setkey(blockdata, "GRID_X","GRID_Y","GRID_Z")  # IS THIS REALLY USED LATER SOMEWHERE? These are not the fields used to make quaddata.
  
  data.table::setkey(blockdata, 'blockfips', 'bgfips')
  # saveRDS(blockdata, file = './data/blockdata2010.rda')
  return(blockdata)
}

