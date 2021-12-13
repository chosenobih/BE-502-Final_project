#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd


# --------------------------------------------------
"""Data Reading"""

fire_dt = pd.read_csv("AZ_2020_fire.csv")

climate_dt = pd.read_csv("fire_location_climate.csv")

# --------------------------------------------------
"""Connect fire name with location climate data"""

fire_climate = []

for row in range(len(fire_dt)):
    climate_lat = climate_dt[climate_dt['Latitude']==fire_dt.iloc[row]['LAT']]
    climate = climate_lat[climate_lat['Longitude']==fire_dt.iloc[row]['LONG']]
    location = np.unique(climate['Name'])[0]
    
    climate['Name'] = str(fire_dt.iloc[row]['INC_Name'])
    
    fire_climate.append(climate)
    
fire_climate = pd.concat(fire_climate)

# --------------------------------------------------
"""Monthly Mean Temp"""

# Sumarize monthly mean temp per fire

# Visualize (chose 5 random locations)
# Plot monthly mean temp over the year (x-axis = month, y-axis=mena temp)
# Boxplot (y-axis = Monthly mean temp, x-axis= fire name) 

# --------------------------------------------------
"""Monthly Total Rainfall"""

# Sumarize monthly total rainfall per fire

# Visualize (chose 5 random locations)
# Plot monthly total rainfall over the year (x-axis = month, y-axis=total rainfall)
# Boxplot (y-axis = Monthly total rainfall, x-axis= fire name) 
    
 
    
 
