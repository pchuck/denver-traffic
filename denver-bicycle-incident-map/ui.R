## denver-traffic, R/Shiny App - ui
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)
library(leaflet)

shinyUI(
    fluidPage(
        titlePanel(paste(TITLE, ": ", minYear, "-", maxYear, sep="")),
        fluidRow(leafletOutput("map")),
        fluidRow(
            column(width=1, ""),
            column(width=4, sliderInput("years", "", min=minYear, max=maxYear,
                                        value = c(minYear, maxYear), sep="")),
            column(width=4, checkboxInput("hitrun", "Hit and Run", FALSE))
        )
    )
)
