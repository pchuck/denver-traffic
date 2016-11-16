## cobble together a static leaflet map
## for a dynamic version of the same using shiny,
##   see ./denver-bicycle-incident-map/
##
library("leaflet")
library("htmlwidgets")

source(file="denver-bicycle-incident-map/global.R")
map <- createBicycleIncidentMap(bicycles, OPACITY, ZOOM_LEVEL)
saveWidget(map, 'denver-bicycle-incident-map.html', selfcontained=TRUE)
