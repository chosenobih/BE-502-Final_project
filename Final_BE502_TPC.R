#install.packages("devtools")
#library(devtools)
install_github("ropensci/prism") #use this instead of install.packages("prism") to get latest version 
packageVersion("prism") #should be >= 0.2.0 (required for 'prism_set_dl_dir')
library(prism)
#library(rgdal)
#library(raster)
library(lubridate)
#install.packages(TDPanalysis)
#library(tpdanalysis)

#clone https://github.com/chosenobih/BE-502-Final_project

#check and change working directory to the directory of the cloned, local github repo
getwd()
setwd("~/BE-502-Final_project") #may need to adjust accordingly
getwd()

####Start#### Only execute the following lines if you wish to re-download the data already contained in 'prism_gridded'

# dir.create("prism_gridded") #creates data archive in the working directory, if 'prism_gridded' does not already exist

# prism_set_dl_dir("./prism_gridded") #set the directory where all prism raster data will be downloaded

# #pull daily precip for all of 2020
# get_prism_dailys(
#   type = "ppt",
#   minDate = "2020-01-01",
#   maxDate = "2020-12-31",
#   keepZip = FALSE
# )



