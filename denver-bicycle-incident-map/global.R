## denver-traffic, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##

# read and transform the Denver open data traffic accident dataset
traffic <- read.csv("data/denver_traffic_accidents.csv",
                    sep=",", header=TRUE, stringsAsFactors=FALSE, 
                    colClasses=c("OFFENSE_TYPE_ID"="factor",
                        "OFFENSE_CATEGORY_ID"="factor",
                        "NEIGHBORHOOD_ID"="factor",
                        "DISTRICT_ID"="factor", "PRECINCT_ID"="factor",
                        "OFFENSE_CODE"="factor"))

# discard wildly inconsistent geo points
traffic <- traffic[!(traffic$GEO_LON > -100), ]

# transform the date fields
traffic$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(traffic$FIRST_OCCURRENCE_DATE,format="%Y-%m-%d %H:%M:%S")

# create a new column with the year component
traffic$OCCURRENCE_YEAR <- 
    as.numeric(format(traffic$FIRST_OCCURRENCE_DATE, "%Y"))

# determine the time range
minYear <- min(traffic$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(traffic$OCCURRENCE_YEAR, na.rm=TRUE)

# extract bicycle, collision and hit and run data subsets
bicycles <- traffic[traffic$BICYCLE_IND %in% c(1), ]
bhr <- bicycles[bicycles$OFFENSE_TYPE_ID %in%
                c("traffic-accident-hit-and-run"), ]
bnhr <- bicycles[!(bicycles$OFFENSE_TYPE_ID %in%
                   c("traffic-accident-hit-and-run")), ]
