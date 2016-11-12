## denver-traffic, R/Shiny App - server
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)
library(leaflet)

# build grouping tags from year of occurrence and incident indicator
tag <- function(year, ind) {
    paste(toString(year), ind, sep="-")
}

# hide leaflet layers by group via the mapping proxy
hide <- function(proxy, min, max) {
    for(year in min:max) {
        proxy %>% # hide hit and hit/run groups for the selected years
            hideGroup(tag(year, HIT_IND)) %>%
            hideGroup(tag(year, RUN_IND))
    }
}

# show year and incident type layers by group via the mapping proxy
show <- function(proxy, min, max, years, hnr) {
    for(year in min:max) { 
        if(year >= min(years) && year <= max(years)) {
            # show hits and/or runs for the selected years
            proxy %>% showGroup(tag(year, HIT_IND)) 
            ifelse(hnr, proxy %>% showGroup(tag(year, RUN_IND)), FALSE)
        }
    }
}

# main shiny server function
function(input, output, session) {
    # render the main map
    output$map <- renderLeaflet({
        # add the background
        background <- leaflet() %>%
            setView(lng=mean(traffic$GEO_LON),
                    lat=mean(traffic$GEO_LAT), zoom=12) %>%
            addLegend(colors=c(HIT_COLOR, RUN_COLOR),
                      labels=c(HIT_TEXT, RUN_TEXT)) %>%
            addProviderTiles(MAP_TYPE,
                             options = providerTileOptions(noWrap = TRUE))

        # overlay the various groups of interest (year and incident type)
        marked <- background
        for(year in minYear:maxYear) {
            subdata <- bicycles[year==bicycles$OCCURRENCE_YEAR, ]
            hnr <- subdata[subdata$OFFENSE_TYPE_ID %in% c(HITRUN_ID), ]
            nhnr <- subdata[!subdata$OFFENSE_TYPE_ID %in% c(HITRUN_ID), ]
            marked <- marked %>%
                addCircleMarkers(lng=nhnr$GEO_LON, lat=nhnr$GEO_LAT,
                                 popup=paste(nhnr$FIRST_OCCURRENCE_DATE,
                                     nhnr$OFFENSE_TYPE_ID, BIKE_IND,
                                     nhnr$INCIDENT_ADDRESS, sep=", "),
                                 color=HIT_COLOR, radius=RADIUS,
                                 group=paste(toString(year), HIT_IND,
                                     sep="-")) %>%
                addCircleMarkers(lng=hnr$GEO_LON, lat=hnr$GEO_LAT,
                                 popup=paste(hnr$FIRST_OCCURRENCE_DATE,
                                     hnr$OFFENSE_TYPE_ID, BIKE_IND,
                                     hnr$INCIDENT_ADDRESS, sep=", "),
                                 color=RUN_COLOR, radius=RADIUS,
                                 group=paste(toString(year), RUN_IND,
                                     sep="-"))
        }
        marked
    })

    # respond to changes in the date slider or 'hit and run' toggle
    observe({
        hitandrun <- input$hitrun
        years <- input$years        
        proxy <- hide(leafletProxy("map", data=bicycles), minYear, maxYear)
        proxy <- show(leafletProxy("map", data=bicycles), minYear, maxYear,
                      years, hitandrun)
    })
}
