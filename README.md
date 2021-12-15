# BE-502-Final_project

- This repository contains the files of `BAT/BE 502 final Project`.

## About

### Team Information

- Team Member : Madeline Melichar 
  - email : mgmelichar@email.arizona.edu
- Team Member : Truman Combs
  - email: tpcombs@email.arizona.edu
- Team Member : Chosen Obih
  - email : chosenobih@email.arizona.edu
- Team Member : Nasser Albalawi
  - email : nasseralbalawi@email.arizona.edu

## Project Prompt 
The project aims to synthesize different parts of knowledge acquired in this course. It is a group project with a team size of 2 to 4. Each group needs to raise a question (or form a hypothesis) about the raining data but should download additional data than the existing Tucson and Weather data in 2018-2020. You will analyze the downloaded data and conclude from the new data. Each group submits one copy of the report, including your research question, workflow, results, and conclusion. It ends with the contribution of each team member. Please attach separate files for the program coded for the project with respective suffix names (.r, .sh, or .py).

## Project Description 
This project aims to observe the effects of monthly climate data on the magnitude of wildfires in Arizona for the year 2020. Fire data for 2020 was collected from the Southwest Coordination Center. The data used in this project consisted of fires categorized as “large” meaning they exceeded 100 acres in timber, 300 acres in grass and brush, or has a Type 1 or 2 incident management team assigned. Variables recorded for each fire included acres burned, the start and end of the fire, the location of the fire (latitude and longitude), as well as the cause and fuel of the fire. In total, there were 103 fires in Arizona during 2020. Daily weather data for each fire location (based on latitude and longitude) was collected from the PRISM Climate Group. The climate data collected consisted of precipitation (inches) and min, max, and mean temperature (degrees F). The daily climate data was then converted to monthly data for the purpose of testing our purposed hypothesis.

## Project Hypothesis
- 'Higher average monthly temperature and lower monthly rainfall leads to an increase in acreage burned.'

## Data Source 
- [Southwest Cordination Center](https://gacc.nifc.gov/swcc/predictive/intelligence/Historical/Fire_and_Resource_Data/Historical_Fires_Acres.htm)
- [PRISM Climate data](https://prism.oregonstate.edu/)

## Software Development Tools
 - Programming Language
    - Python
    - R   

## Workflow Reports
Chosen 

Nasser

Madeline: Statistical Analysis
The initial statistical analysis performed involved observing the distribution of fires through the year. We predicted that we would see the most fires occur in the summer months given the hotter temperatures and scattered rain events in Arizona. From the histogram shown below (“Active Fires/Month of 2020”), our prediction was supported. The histogram was created using the R base function hist(). The distribution of the histogram has a shifted bell shape, with a peak in July and no fires occurring in the months of January, February, March, or December.
 
Histogram of active fires per month of 2020. If a fire started and ended in separate months, the fire was considered “active” for both months.

An ANOVA test was performed using the R function aov(), to estimate how the dependent variable (acres burned) changes according to the levels of the independent variables (total monthly rain, mean monthly temperature, the month, the cause of the fire, and the fuel vegetation of the fire). The ANOVA table below shows that neither the total monthly rain, mean monthly temperature, or month is statistically significant to the number of acres burned because they all have a p-value > 0.05 (Pr(>F) column). The results do show that the cause and fuels of the fire do have a statically significant effect on the acres burned because they have a p-value < 0.05. When observing the interactions between the month and total mean rain and mean temperature, the interactions show no statistically significant effect on the number of acres burned.

 
ANOVA table for monthly climate data and annual fire data in 2020.

From these results, further improvements to this project could look at fire and climate data for consecutive years to draw conclusions about the effects of climate temperature and precipitation on acers burned.  Climate data could also be limited to the duration in which the fire was burning or to the period prior to the fire burning. This could provide a deeper look at possible climatic causes and influences on the fire’s magnitude.

Truman

## License
