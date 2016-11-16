## denver-traffic, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
source(file="functions.R")

# various constants
TITLE <- "Denver Traffic Accidents Involving Bicycles"
BIKE_LOCAL <- "data/denver_bike_accidents.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data
MAP_TYPE <- "Stamen.TonerLite" # underlying map tile source/type
ZOOM_LEVEL <- 13 # initial map zoom level
RADIUS <- 3.0 # marker radius
HIT_COLOR <- "red" # and colors..
RUN_COLOR <- "black"
OPACITY <- 0.5
HIT_TEXT <- "Collision" # and legend text.. 
RUN_TEXT <- "Hit and Run"
HIT_IND <- "hit" # and incident grouping map keys..
RUN_IND <- "hitandrun" 
BIKE_IND <- "bicycle" # visual indicator used on popups
HITRUN_ID <- "traffic-accident-hit-and-run" # dataset incident id for hit/run
BAD_LON <- -100 # consider datapoints outside this longitude invalid

# read and transform the Denver open data traffic accident dataset
bicycles <- readDenverCrime(BIKE_LOCAL)

# discard wildly inconsistent geo points
bicycles <- bicycles[!(bicycles$GEO_LON > BAD_LON), ]

# transform the date fields
bicycles$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(bicycles$FIRST_OCCURRENCE_DATE, format=DATE_FORMAT)

# create a new column with the year component
bicycles$OCCURRENCE_YEAR <- 
    as.numeric(format(bicycles$FIRST_OCCURRENCE_DATE, "%Y"))

# determine the time range
minYear <- min(bicycles$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(bicycles$OCCURRENCE_YEAR, na.rm=TRUE)


