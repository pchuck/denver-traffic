## util funcs for Denver data acquistion and transform
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##

# acquire a copy of the data from the Open Data repository
acquireAndSave <- function(source_url, dest_path) {
    download.file(url=source_url, destfile=dest_path, method='wget')
}

# read denver crime format sources (e.g. denver traffic data, crime data, etc)
readDenverCrime <- function(source) {
    read.csv(source, sep=",", header=TRUE, stringsAsFactors=FALSE, 
             colClasses=c("OFFENSE_CODE"="factor",
                          "OFFENSE_CODE_EXTENSION"="factor",
                          "OFFENSE_TYPE_ID"="factor",
                          "OFFENSE_CATEGORY_ID"="factor",
                          "INCIDENT_ADDRESS"="character",
                          "DISTRICT_ID"="factor",
                          "PRECINCT_ID"="factor",
                          "NEIGHBORHOOD_ID"="factor"))
}

# write denver crime format data to disk
saveDenverCrime <- function(df, dest) {
    write.csv(df, file=dest)
}
    
# extract a subset of the data including only bicycle incidents
subsetBicycles <- function(traffic) {
    bicycles <- traffic[traffic$BICYCLE_IND %in% c(1), ]
}

# render a traffic map, with the specified overlay groups and marker settings
#   color by collision vs. hit and run
#   instruments group codes by year and incident type for interactive shiny app
#   relies on vars from globals: HIT_{COLOR, TEXT} RUN_{COLOR_TEXT}, MAP_TYPE
createBicycleIncidentMap <- function(traffic, opacity, zoom) {
        # add the background
        base <- leaflet(traffic) %>%
            setView(lng=mean(traffic$GEO_LON), lat=mean(traffic$GEO_LAT),
                    zoom=zoom) %>%
            addLegend(colors=c(HIT_COLOR, RUN_COLOR),
                      labels=c(HIT_TEXT, RUN_TEXT)) %>%
            addTiles(group="OSM") %>%
            addProviderTiles("Thunderforest.OpenCycleMap", group="Cycle") %>%
            addProviderTiles("Stamen.TonerLite", group="Toner")

        # build the popup text
        popupText <- function(data) {
            paste(data$FIRST_OCCURRENCE_DATE,
                  data$OFFENSE_TYPE_ID, BIKE_IND,
                  data$INCIDENT_ADDRESS, sep=", ")
        }
        
        # overlay the various groups of interest (year and incident type)
        marked <- base
        for(year in minYear:maxYear) {
            yearStr <- toString(year)
            subdata <- traffic[year==traffic$OCCURRENCE_YEAR, ]
            hnr <- subdata[subdata$OFFENSE_TYPE_ID %in% c(HITRUN_ID), ]
            nhnr <- subdata[!subdata$OFFENSE_TYPE_ID %in% c(HITRUN_ID), ]
            marked <- marked %>%
                addCircleMarkers(lng=nhnr$GEO_LON, lat=nhnr$GEO_LAT,
                                 popup=popupText(nhnr), color=HIT_COLOR,
                                 radius=RADIUS, fillOpacity=opacity, 
                                 group=paste(yearStr, HIT_IND, sep="-")) %>%
                addCircleMarkers(lng=hnr$GEO_LON, lat=hnr$GEO_LAT,
                                 popup=popupText(hnr), color=RUN_COLOR,
                                 radius=RADIUS, fillOpacity=opacity, 
                                 group=paste(yearStr, RUN_IND, sep="-")) %>%
                addLayersControl(baseGroups=c("Toner", "OSM", "Cycle"),
                                 options=layersControlOptions(collapsed=TRUE),
                                 position="bottomright")
        }
        marked
}

