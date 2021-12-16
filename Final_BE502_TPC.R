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

setwd("~/FinalProj") #may need to adjust accordingly

dir.create("prism_data") #creates data archive in the working directory

prism_set_dl_dir("./prism_data")
