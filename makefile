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

# run shiny server locally
run_app:
	R -e "shiny::runApp('denver-bicycle-incident-map', display.mode='showcase')"

# register w. shiny credentials
shinyio:
	R -e "shinyapps::setAccountInfo(name='', token='', secret='')

# deploy to shinyapps.io
deploy_app:
	R -e "shinyapps::deployApp('denver-bicycle-incident-map')"


## environment 

# tmuxinator an R dev environment
create_env:
	tmuxinator start r-sandbox

# remove generated files
clean:
	rm -f *.html *.md
	rm -rf figure/

