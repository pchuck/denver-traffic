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
        createBicycleIncidentMap(bicycles, OPACITY, ZOOM_LEVEL)
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
