# denver open data traffic analysis
#
# exploratory analysis of traffic accident data set
#

## render main report
render:
	./R/rmdToHtml.R traffic


## shiny application

# install prerequisite packages
prereqs:
	R -e "install.packages(c('devtools', 'shiny'), repos='http://cran.us.r-project.org'); devtools::install_github('rstudio/shinyapps')"

# acquire data from the Open Data source and segment for specific apps
acquire_data:
	R -e "source(file='refresh-data.R')"
	cp data/denver_bike_accidents.csv denver-bicycle-incident-map/data/

# run shiny server locally
run_app:
	R -e "shiny::runApp('denver-bicycle-incident-map', display.mode='showcase')"

# create a static copy of the app for ghpages
create_static_map:
	R -e "source(file='denver-bicycle-incident-map.R')"
	mv denver-bicycle-incident-map.html gh-pages/

# register w. shiny credentials
shinyio:
	R -e "shinyapps::setAccountInfo(name='', token='', secret='')

# deploy to shinyapps.io
deploy_app:
	R -e "shinyapps::deployApp('denver-bicycle-incident-map')"

# deply to ghpages
deploy_ghpages: create_static_map
	git subtree push --prefix gh-pages/ origin gh-pages


## environment 

# tmuxinator an R dev environment
create_env:
	tmuxinator start r-sandbox

# remove generated files
clean:
	rm -f *.html *.md
	rm -rf figure/

