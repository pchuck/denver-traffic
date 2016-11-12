## denver-traffic, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##

# various constants
TITLE <- "Denver Traffic Accidents Involving Bicycles"
SOURCE <- "data/denver_traffic_accidents.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data
MAP_TYPE <- "Stamen.TonerLite" # underlying map tile source/type
RADIUS <- 3.0 # marker radius
HIT_COLOR <- "red" # and colors..
RUN_COLOR <- "black"
HIT_TEXT <- "Collision" # and legend text.. 
RUN_TEXT <- "Hit and Run"
HIT_IND <- "hit" # and incident grouping map keys..
RUN_IND <- "hitandrun" 
BIKE_IND <- "bicycle" # visual indicator used on popups
HITRUN_ID <- "traffic-accident-hit-and-run" # dataset incident id for hit/run
BAD_LON <- -100 # consider datapoints outside this longitude invalid

# read and transform the Denver open data traffic accident dataset
traffic <- read.csv(SOURCE,
                    sep=",", header=TRUE, stringsAsFactors=FALSE, 
                    colClasses=c("OFFENSE_TYPE_ID"="factor",
                        "OFFENSE_CATEGORY_ID"="factor",
                        "NEIGHBORHOOD_ID"="factor",
                        "DISTRICT_ID"="factor", "PRECINCT_ID"="factor",
                        "OFFENSE_CODE"="factor"))

# discard wildly inconsistent geo points
traffic <- traffic[!(traffic$GEO_LON > BAD_LON), ]

# transform the date fields
traffic$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(traffic$FIRST_OCCURRENCE_DATE, format=DATE_FORMAT)

# create a new column with the year component
traffic$OCCURRENCE_YEAR <- 
    as.numeric(format(traffic$FIRST_OCCURRENCE_DATE, "%Y"))

# determine the time range
minYear <- min(traffic$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(traffic$OCCURRENCE_YEAR, na.rm=TRUE)

# extract subset of incidents involving bicycles
bicycles <- traffic[traffic$BICYCLE_IND %in% c(1), ]

