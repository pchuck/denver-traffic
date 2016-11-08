# denver open data traffic analysis
#
# exploratory analysis of traffic accident data set
#

# tmuxinator an R dev environment
create_env:
	tmuxinator start r-sandbox

render:
	./R/rmdToHtml.R traffic

# remove generated files
clean:
	rm -f *.html *.md
	rm -rf figure/

