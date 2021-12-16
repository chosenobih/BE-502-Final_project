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

# #pull mean daily temps -- not used in analysis, but already included in Github 'prism_gridded' folder (could be useful)
# get_prism_dailys(
#   type = "tmean",
#   minDate = "2020-01-01",
#   maxDate = "2020-12-31",
#   keepZip = FALSE
# )

# #Monthly Data - Both of the following datasets are also already included in 'prism_gridded'
# get_prism_monthlys(type = "tmean", year = 2020, mon = 1:12, keepZip = FALSE) #downloading prism 'monthly tmean' data to directory above
# get_prism_monthlys(type = "ppt", year = 2020, mon = 1:12, keepZip = FALSE) #downloading prism 'monthly ppt' data to directory above

# #30-year Normal Annual Data - Both of the following datasets are also already included in 'prism_gridded'
# get_prism_normals("tmean", "4km", mon = NULL, annual = TRUE, keepZip = FALSE)
# get_prism_normals("ppt", "4km", mon = NULL, annual = TRUE, keepZip = FALSE)

####End#### A new 'prism_gridded' directory would now contain all of the same data that is already available in the Github version of the folder


#Import ancillary data for use in analysis

fire = read.csv(file = 'AZ_2020_fire.csv') # read in csv fire data
# head(fire) # visualize a subset of the full dataset


