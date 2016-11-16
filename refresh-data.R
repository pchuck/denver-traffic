## script to refresh from source and segment local copy of Denver traffic data
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
source(file="functions.R")

TRAFFIC_URL <- "http://data.denvergov.org/download/gis/traffic_accidents/csv/traffic_accidents.csv"
TRAFFIC_FULL_LOCAL <- "data/denver_traffic_accidents_full.csv"
BIKE_LOCAL <- "data/denver_bike_accidents.csv"

acquireAndSave(TRAFFIC_URL, TRAFFIC_FULL_LOCAL)
traffic <- readDenverCrime(TRAFFIC_FULL_LOCAL)

# traffic accident subset of all crimes
saveDenverCrime(subsetBicycles(traffic), BIKE_LOCAL)



