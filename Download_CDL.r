#remove all objects
rm(list=ls())

#load libraries 
library(data.table)
library(raster)
library(RCurl) 
library(httr)

wkpath <- 'd:/data/CDL/'
setwd(wkpath)
dir()

# prepare download links 
states <- c('IL','IN','IA','KS','MI','MN','MO','NE','ND','OH','SD','WI') 
years  <- c(1999,2000,2000,2006,2007,2006,1999,2001,1997,2006,2006,2003) 
# the metadata about availability of state cdl at https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php
# you can add more states into the list with correct starting year and state fips code 
stfips <- c(17,18,19,20,26,27,29,31,38,39,46,55)


for (i in c(1:12)) { 

  state <- states[i]
  cat(sprintf('working on state of %s\n',state))
  fips  <- stfips[i]

for (yr in c(years[i]:2020)) {
  cat(sprintf('  on year %d',yr))
  downfile     <- paste0('CDL_',toString(yr),'_',toString(fips),'.tif') 
  downloadlink <- paste0('https://nassgeodata.gmu.edu/webservice/nass_data_cache/byfips/',downfile)
  httr::GET(downloadlink,write_disk(downfile,overwrite = TRUE)) 
  cat(sprintf('   Done!\n')) 
}

}
