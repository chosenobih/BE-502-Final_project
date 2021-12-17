#install.packages("devtools")
#library(devtools)
install_github("ropensci/prism") #use this instead of install.packages("prism") to get latest version 
packageVersion("prism") #should be >= 0.2.0 (required for 'prism_set_dl_dir')
library(prism)
library(rgdal)
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

prism_set_dl_dir("./prism_gridded") #set the directory where all prism raster data will be downloaded

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


####Start#### Visualize 30-year normal annual data for the entire continental US, for perspective
datatypes <- c("tmean", "ppt")

for (i in datatypes) {
  annual_normal <- prism_archive_subset(
    i, "annual normals", resolution = "4km"
  )
  pd_image(annual_normal)
  
}

####End####


####Start#### Import ancillary data for use in analysis

fire = read.csv(file = 'AZ_2020_fire.csv') # read in csv fire data
# head(fire) # visualize a subset of the full dataset

state <- readOGR("./AZ_TPC/Arizona_boundary.shp") #Shapefile boundary of the state of Arizona

####End####


####Start#### Create a RasterStack (3-D gridded object with multiple layers corresponding to each day of 2020) of Daily 'tmean' data

stack = pd_stack(prism_archive_subset(
  "tmean", "daily", 
  minDate = "2020-01-01", 
  maxDate = "2020-12-31"))
#dim(stack) #visualize stack dimensions

stack_df <- as.data.frame(stack[[1]])

dim(stack_df)

stack.sub <- crop(stack, extent(state))

clip.sub <- mask(stack.sub, state)

clip.sub_df <- as.data.frame(clip.sub)

fire_variables = c("Fuels1", "Cause", "Agency")  #defining relevant variables from 'fire' csv
fire_sub = fire[,fire_variables]

for (i in colnames(fire_sub)) {
  plot(clip.sub[[1]], ylab="latitude", xlab="longitude", main= "Mean Temp for January 1, 2020") # adjust clip.sub[[]] band to view different days of the year
  plot(state, add = TRUE)
  points(fire$LONG, fire$LAT, pch = 16, col = fire_sub[[i]])
  legend(x = "left",                           # Add points to legend
         legend = unique(fire_sub[[i]]),
         text.col = "black",
         lwd = 1,
         col = unique(fire_sub[[i]]),
         lty = c(0, 0),
         pch = 16,
         bty = "n",
         cex = 0.50,
         pt.cex = 1)
}


####End####


####Start#### Extract and visualize total monthly precipitation and mean monthly temperature for a subset of the fires

len <- dim(fire)[1] # number of fires in the fire dataset

list_ppt <- vector(mode = "list", length = len) #list will contain all 2020 monthly ppt data for all sites
list_tmean <- vector(mode = "list", length = len) #list will contain all 2020 monthly tmean data for all sites
list_site <- c() #storing 12 months for each fire in vector for future use

#loops through all sites to extract site name and mean monthly temp -- takes a few minutes
for (i in 1:dim(fire)[1]) {
  temp_list <- rep(toString(fire$INC_Name[i]), length = 12)
  list_site <- c(list_site, temp_list)
  
  coords <- c(fire$LONG[i], fire$LAT[i])
  list_ppt[i] <- pd_plot_slice(
    prism_archive_subset("ppt", "monthly", year = 2020),
    coords)
  list_tmean[i] <- pd_plot_slice(
    prism_archive_subset("tmean", "monthly", year = 2020),
    coords)
  print(i)
}

#converts list data into data frame
df = do.call(rbind.data.frame, list_ppt) #create ppt dataframe from ppt list
df_tmean = do.call(rbind.data.frame, list_tmean) #create dataframe from tmean list
df['tmean'] = df_tmean$data #add site name column to dataframe
df['name'] = list_site #add site name column to dataframe
colnames(df) <- c('Precip_mm','Date', 'Mean_Temp_C', 'Site_Name')

site_sub = 5 #number of sites to visualize; change this # to add/remove site count
months = 12 #number of months for which data are available in 2020
pt_count = site_sub*months
df_sub = df[1:pt_count,] #subset the dataframe

plot(df_sub$Date, df_sub$Precip_mm, pch = 16, col = factor(df_sub$Site_Name), main="Monthly Precip: 5 Sites",
     xlab="Month", ylab="Total Rainfall (mm)")
legend(x = "topright",                           # Add points to legend
       legend = unique(df_sub$Site_Name),
       text.col = "black",
       lwd = 1,
       col = unique(factor(df_sub$Site_Name)),
       lty = c(0, 0),
       pch = 16,
       bty = "n",
       cex = 0.50,
       pt.cex = 1)

plot(df_sub$Date, df_sub$Mean_Temp_C, pch = 16, col = factor(df_sub$Site_Name), main="Mean Monthly Temp: 5 Sites",
     xlab="Month", ylab="Degrees Celcius")
legend(x = "topright",                           # Add points to legend
       legend = unique(df_sub$Site_Name),
       text.col = "black",
       lwd = 1,
       col = unique(factor(df_sub$Site_Name)),
       lty = c(0, 0),
       pch = 16,
       bty = "n",
       cex = 0.50,
       pt.cex = 1)

####End####


####Start#### Assess whether cumulative rainfall based on daily PRISM precip data correlates with burn duration or acreage burned

#create a new stack based on precip data for all 2020 (tmean is stack above)
ppt_stack = pd_stack(prism_archive_subset( 
  "ppt", "daily", 
  minDate = "2020-01-01", 
  maxDate = "2020-12-31"))

ppt_stack.sub <- crop(ppt_stack, extent(state)) #crop ppt stack to the dimensions of AZ

ppt_clip.sub <- mask(ppt_stack.sub, state) #mask out regions not contained within the shapefile boundaries

ppt_sum.sub <- calc(ppt_clip.sub, cumsum) #create a new stack based on a running, cumulative sum from band to band


for (i in colnames(fire_sub)) {
  plot(ppt_sum.sub[[1]], ylab="latitude", xlab="longitude", main= "Total Precip for January 1, 2020") # adjust ppt_sum.sub[[]] band to view different running sum based on day-of-year as stack band
  plot(state, add = TRUE)
  points(fire$LONG, fire$LAT, pch = 16, col = fire_sub[[i]])
  legend(x = "left",                           # Add points to legend
         legend = unique(fire_sub[[i]]),
         text.col = "black",
         lwd = 1,
         col = unique(fire_sub[[i]]),
         lty = c(0, 0),
         pch = 16,
         bty = "n",
         cex = 0.50,
         pt.cex = 1)
}


#perform caluclations for preparing final ppt data for analyses
lubridate()

start_doy <- c() #start of each fire as day-of-year
end_doy <- c() #end of each fire as day-of-year
duration <- c() # how long each fire lasts, from start to end
acres_burned <- c() #pulled directly from 'fire' csv as acreage burned for each fire
sum_ppt_start = c() #sum of the total rainfall occurring at each site leading up to the start of fire event (i.e., Jan 1, 2020 -> start_doy)
sum_ppt_end = c() #sum of the total rainfall occurring at each site leading up to the end of fire event (i.e., Jan 1, 2020 -> end_doy)

#extracting geographic information for all wildfire sites
lat = fire$LAT
long = fire$LONG
coords = data.frame(lat, long)
#print(coords)
firstPoints <- SpatialPoints(coords = cbind(fire$LONG,fire$LAT))
print(firstPoints)

for (i in 1:dim(fire)[1]) {
  
  #get start dates and convert to DOY, store as vector
  start_date <- toString(fire$Start[i])
  start_date <- mdy(start_date)
  start_doy[i] <- yday(start_date)
  
  #get end dates, store as vector
  end_date <- toString(fire$End[i])
  end_date <- mdy(end_date)
  end_doy[i] <- yday(end_date)
  
  #compute duration of fire events, store as vector
  duration[i] <- end_doy[i] - start_doy[i]
  
  #get acreage burned for each fire event, store as vector
  acres_burned[i] <- toString(fire$Acres[i])
}

#calculating a running sum of cumulative precipitation for each site based on start and end of fire
for (i in 1:dim(fire)[1]){
  start = start_doy[i]
  end = end_doy[i]

  sum_ppt_start[i] = extract(ppt_sum.sub, firstPoints[i], layer = start, nl = 1)
  sum_ppt_end[i] = extract(ppt_sum.sub, firstPoints[i], layer = end, nl = 1)
}

#print(sum_ppt_start) #running sum of 
#print(sum_ppt_end)
#print(start_doy)
#print(end_doy)
#print(duration)
#print(acres_burned)

plot(sum_ppt_start, acres_burned, ylab="Acres Burned", xlab="Precip (mm)", main= "Cumulative Precip to Start Date vs Acreage Burned")

cor(sum_ppt_start, as.numeric(acres_burned), method = c("pearson"))
cor.test(sum_ppt_start, as.numeric(acres_burned), method=c("pearson"))

plot(sum_ppt_start, duration, ylab="Days of Fire", xlab="Precip (mm)", main= "Cumulative Precip to Start Date vs Burn Duration")

cor(sum_ppt_start, duration, method = c("pearson"))
cor.test(sum_ppt_start, duration, method=c("pearson"))

plot(sum_ppt_end, acres_burned, ylab="Acres Burned", xlab="Precip (mm)", main= "Cumulative Precip to End Date vs Acreage Burned")

cor(sum_ppt_end, as.numeric(acres_burned), method = c("pearson"))
cor.test(sum_ppt_end, as.numeric(acres_burned), method=c("pearson"))

plot(sum_ppt_end, duration, ylab="Days of Fire", xlab="Precip (mm)", main= "Cumulative Precip to End Date vs Burn Duration")

cor(sum_ppt_end, duration, method = c("pearson"))
cor.test(sum_ppt_end, duration, method=c("pearson"))









