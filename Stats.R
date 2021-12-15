# Author: Madeline Melichar
# University of Arizona
# Date: December 16, 2021

#-------------------------------------------------------------------------------
# Load Packages

library(dplyr)
library(plyr)
library(tidyr)


#-------------------------------------------------------------------------------
# Read in data

fire_dt <- read.csv2("AZ_2020_fire.csv", header=T, sep=",")
climate_dt <- read.csv2("fire_location_climate.csv", header=T, sep=",")
climate_dt<-climate_dt %>% drop_na


#-------------------------------------------------------------------------------
# Connect climate data to fire

# New data frame for monthly climate data
climate_monthly <- data.frame()

# New data frame for annual climate data
climate_annual <- data.frame()

# List of month which fire occurs
fire_months <- c()

# Subset climate data based on fire
for (row in 1:nrow(fire_dt)){
  # Subset climate data based on fire latitude and longitude
  df <- climate_dt[climate_dt$Latitude==toString(fire_dt[row,]$LAT) &
                     climate_dt$Longitude==toString(fire_dt[row,]$LONG),]
  # Set data class
  df[,6]<-as.numeric(as.character(df[,6]))
  df[,7]<-as.numeric(as.character(df[,7]))
  df[,8]<-as.numeric(as.character(df[,8]))
  df[,9]<-as.numeric(as.character(df[,9]))
  
  # yr_sum<-data.frame(name=toupper(toString(fire_dt[row,]$INC_Name)),
  #                       acres=fire_dt[row,]$Acres,
  #                       cause=fire_dt[row,]$Cause,
  #                       fuels=fire_dt[row,]$Fuels1,
  #                       total_rain=sum(df$ppt..inches.),
  #                       mean_temp=mean(df$tmean..degrees.F.))
  # 
  # # Append yearly data by row
  # climate_annual<-rbind(climate_annual,yr_sum)
  
  for (month in 1:12){
    df_month <- df[grep(paste("^", paste0(month),sep = ""),df$Date),]
    
    temp_mean <- mean(df_month$tmean..degrees.F.)
    tot_rain <- sum(df_month$ppt..inches.)
    
    month_sum<-data.frame(name=toupper(toString(fire_dt[row,]$INC_Name)),
                          month=month,
                          acres=fire_dt[row,]$Acres,
                          cause=fire_dt[row,]$Cause,
                          fuels=fire_dt[row,]$Fuels1,
                          total_rain=tot_rain,
                          mean_temp=temp_mean)
    # Append monthly data by row
    climate_monthly<-rbind(climate_monthly,month_sum)
  }
  
  # Find month fire starts
  fire_start <- sub("\\/.*", "", fire_dt[row,]$Start)
  # Find month fire ends
  fire_end <- sub("\\/.*", "", fire_dt[row,]$End)
  
  # Append to list of month fire occurs
  if (fire_start != fire_end){
    # if start and end are in different months
    fire_months<-c(fire_months,fire_start,fire_end)
  } else {
    # if start and end are the same month
    fire_months<-c(fire_months,fire_start)
  }
  
}


#-------------------------------------------------------------------------------
# Histogram of fire frequency per month of 2020

his<-hist(as.numeric(fire_months), main = "Active Fires/Month of 2020", 
     xlab = "Month", ylab = "Number of Active Fires",
     xlim=c(0,13),
     xaxt="n")
axis(1, at=0:13, labels=c('',"Jan","Feb","Mar","Apr","May","Jun",
                                    "Jul","Aug","Sep","Oct","Nov","Dec",''))


#-------------------------------------------------------------------------------
# ANOVA

anova <- aov(as.numeric(as.character(acres))~total_rain+mean_temp+month+cause+fuels+month*total_rain+month*mean_temp,
             data = climate_monthly)
summary(anova)
