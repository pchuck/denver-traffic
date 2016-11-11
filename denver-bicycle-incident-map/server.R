## denver-traffic, R/Shiny App - server
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)
library(leaflet)

# hide leaflet layers by group via the mapping proxy
hide <- function(proxy, min, max) {
    for(year in min:max) {
        h <- paste(toString(year), "hit", sep="-")
        hr <- paste(toString(year), "hitandrun", sep="-")
        proxy %>% hideGroup(h) %>% hideGroup(hr)
    }
}

# show year and incident type layers by group via the mapping proxy
show <- function(proxy, min, max, years, hnr) {
    for(year in min:max) {
        if(year >= min(years) && year <= max(years)) {
            h <- paste(toString(year), "hit", sep="-")
            hr <- paste(toString(year), "hitandrun", sep="-")
            if(hnr) {
                proxy %>% showGroup(h) %>% showGroup(hr)
            }
            else {
                proxy %>% showGroup(h)
            }
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
                addProviderTiles("Stamen.TonerLite",
                                 options = providerTileOptions(noWrap = TRUE))

        # overlay the various groups of interest (year and incident type)
        marked <- background
        for(year in minYear:maxYear) {
            subdata <- bicycles[year==bicycles$OCCURRENCE_YEAR, ]
            hnr <- subdata[subdata$OFFENSE_TYPE_ID %in%
                           c("traffic-accident-hit-and-run"), ]
            nhnr <- subdata[!subdata$OFFENSE_TYPE_ID %in%
                            c("traffic-accident-hit-and-run"), ]
            marked <- marked %>%
                addCircleMarkers(lng=nhnr$GEO_LON,
                                 lat=nhnr$GEO_LAT,
                                 popup=paste(nhnr$FIRST_OCCURRENCE_DATE,
                                     nhnr$OFFENSE_TYPE_ID, "bicycle",
                                     nhnr$INCIDENT_ADDRESS, sep=", "),
                                 color="red", radius=3.0,
                                 group=paste(toString(year), "hit",
                                     sep="-")) %>%
                addCircleMarkers(lng=hnr$GEO_LON,
                                 lat=hnr$GEO_LAT,
                                 popup=paste(hnr$FIRST_OCCURRENCE_DATE,
                                     hnr$OFFENSE_TYPE_ID, "bicycle",
                                     hnr$INCIDENT_ADDRESS, sep=", "),
                                 color="black", radius=3.0,
                                 group=paste(toString(year), "hitandrun",
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

