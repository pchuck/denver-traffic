# in an environment seeded by traffic.Rmd,
# the following code will display a leaflet visualization

bhr <-
    bicycles[bicycles$OFFENSE_TYPE_ID %in% c("traffic-accident-hit-and-run"), ]
bnhr <-
    bicycles[!(bicycles$OFFENSE_TYPE_ID %in% c("traffic-accident-hit-and-run")), ]

bicycle_interactive <- leaflet() %>%
    setView(lng=mean(bicycles$GEO_LON),
            lat=mean(bicycles$GEO_LAT), zoom=12) %>%
    addTiles() %>%
    addCircleMarkers(lng=jitter(bicycles$GEO_LON, factor=0.0001),
                     lat=jitter(bicycles$GEO_LAT, factor=0.0001),
        popup=paste(bicycles$FIRST_OCCURRENCE_DATE, bicycles$OFFENSE_TYPE_ID, "bicycle", bicycles$INCIDENT_ADDRESS, sep=", "), color="white", radius=6, clusterOptions = markerClusterOptions(), fillOpacity=0.0) %>%

    addCircleMarkers(lng=jitter(bnhr$GEO_LON, factor=0.0001),
                     lat=jitter(bnhr$GEO_LAT, factor=0.0001),
      popup=paste(bnhr$FIRST_OCCURRENCE_DATE, bnhr$OFFENSE_TYPE_ID, "bicycle", bnhr$INCIDENT_ADDRESS, sep=", "), color="red", radius=6) %>%

    addCircleMarkers(lng=jitter(bhr$GEO_LON, factor=0.0001),
                     lat=jitter(bhr$GEO_LAT, factor=0.0001),
      popup=paste(bhr$FIRST_OCCURRENCE_DATE, bhr$OFFENSE_TYPE_ID, "bicycle", bhr$INCIDENT_ADDRESS, sep=", "), color="black", radius=6)

bicycle_interactive
