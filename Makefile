.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

all: hw07_report.html hw07_report.pdf

clean:
	rm -f data.csv tidy_data.csv analysed_data.csv barplot.png
	rm -f hw07_report.md hw07_report.html hw07_report.pdf
	rm -r hw07_report_files #removes folder w/files from .Rmd eg scatterplot

# Download data
data.csv:
	Rscript -e 'download.file("https://gist.githubusercontent.com/ksedivyhaley/e2f14be8af057fb34610091bd424d32d/raw/656053fb64150735e403d83929ea67bbb0aa646f/test.csv", destfile = "data.csv", quiet = TRUE)'

# tidy and analyse data
tidy_data.csv: tidy.r data.csv
	Rscript $<
	
analysed_data.csv: analysis.r tidy_data.csv
	Rscript $<

# generate and save barplot from data
barplot.png: barplot.r analysed_data.csv
	Rscript $<
	rm Rplots.pdf

# create reports from rmd
hw07_report.html: hw07_report.rmd barplot.png scatterplot.r analysed_data.csv tidy_data.csv data.csv
	Rscript -e 'rmarkdown::render("$<")'

hw07_report.md: hw07_report.rmd barplot.png analysed_data.csv data.csv
	Rscript -e 'rmarkdown::render("$<")'
	rm -f hw07_report.html #only gets called if I request .pdf without .html

hw07_report.pdf: hw07_report.md barplot.png
	pandoc -o hw07_report.pdf hw07_report.md