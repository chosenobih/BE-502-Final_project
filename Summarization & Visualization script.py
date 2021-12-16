#!/usr/bin/env python3
# ***************************************************#
# Authors: Nasser Albalawi and Chosen Obih
# Date: 12/8/2021 - updated 12/16/2021
# Description: This script obtains the mean temperature, rain and number of fires per month in the year 2020 for the state of Arizona
# rain ppt monthly average (first file)
# temperature monthly average (first file)
# total number of fires (second file)
# fires per month chart
# total number of acres burned (second file)
# Count of causes (Human, Lightning, Unknown)
# Graph of average temperature per month
# **************************************************#

import pandas as pd
import datetime
import seaborn as sb
import matplotlib.pyplot as plt


def main():
    # Read and drop na lines
    fire1 = pd.read_csv("~/Desktop/BE502/final project doc/fire_location_climate.csv").dropna().reset_index(
        drop=True)
    fire2 = pd.read_csv("~/Desktop/BE502/final project doc/AZ_2020_fire.csv").dropna().reset_index(drop=True)

    # Splitting into date
    dates = fire1['Date'].str.split('/')
    fire1['year'] = [dates[i][2] for i in dates.index]
    fire1['month'] = [dates[i][0] for i in dates.index]
    fire1['day'] = [dates[i][1] for i in dates.index]

    fire1Average = pd.DataFrame(fire1.groupby(["year", "month"], axis=0, as_index=True).mean())
    months = list(range(1, 12 + 1))
    fire1TempAverage = fire1Average["tmean (degrees F)"]
    fire1RainAverage = fire1Average["ppt (inches)"]

    data1 = pd.DataFrame()
    data1["Months"] = months
    data1["Rain Average (ppt)"] = list(fire1RainAverage)
    data1["Temperature Average (F)"] = list(fire1TempAverage)
    data1 = data1.round(decimals=4)

    # Plotting of the average rain per month
    data1.plot(x="Months", y=["Rain Average (ppt)"], kind="bar", figsize=(7, 7))
    plt.title("Average Rain fall/Month")
    plt.xlabel("Months")
    plt.ylabel("Rain Average (ppt)")
    plt.show()

    # Plotting of the average temperature per month
    data1.plot(x="Months", y=["Temperature Average (F)"], kind="bar", figsize=(7, 7))
    plt.title("Average temperature/Month")
    plt.xlabel("Months")
    plt.ylabel("Temperature Average (F)")
    plt.show()

    # Print the result of Average Rain and Temperature in csv file
    data1.to_csv("C:\\Users\\Owner\\Desktop\\Project_Fire\\Average_Temp_and_Rain.csv")

    print("Done with File 1!")

    # Because of some fires going on for multiple months, a fire will be counted by its start date.
    # For example, if a fire started in May, and ended in October, it will count as one fire in May
    # and not count as a fire in any of the subsequent months.

    countOfFires = fire2.shape[0]  # count of fires
    totalAcres = fire2['Acres'].sum()

    fireDict = {}
    for monthNumber in months:
        fireDict[str(monthNumber)] = 0
    # print(fireDict)

    # Splitting into date
    dates = fire2['Start'].str.split('/')
    fire2['year'] = [dates[i][2] for i in dates.index]
    fire2['month'] = [dates[i][0] for i in dates.index]
    fire2['day'] = [dates[i][1] for i in dates.index]
    fire2CountPerMonth = pd.DataFrame(fire2.groupby(["month"], axis=0, as_index=True).count())
    fire2Causes = pd.DataFrame(pd.DataFrame(fire2.groupby(["Cause"], axis=0, as_index=True).count())["INC_Name"])
    fire2Counts = fire2CountPerMonth["INC_Name"]
    data2 = pd.DataFrame()

    for monthNumber in list(fireDict.keys()):
        if monthNumber in fire2Counts.index:
            fireDict[str(monthNumber)] = fire2Counts[str(monthNumber)]
    data2["Months"] = months
    data2["Number of fires per month"] = list(fireDict.values())
    data2 = data2.round(decimals=4)
    #row = pd.Series(["Total number of fires", countOfFires], index=data2.columns)
    #row2 = pd.Series(["Total number of Acres burned", totalAcres], index=data2.columns)
    #data2 = data2.append(row, ignore_index=True)
    #data2 = data2.append(row2, ignore_index=True)

    # Plotting of number of fires in each month of the year 2020
    data2.plot(x="Months", y=["Number of fires per month"], kind="bar", figsize=(7, 7))
    plt.title("Number of fire/Month")
    plt.xlabel("Months")
    plt.ylabel("Number of fires per month")
    plt.show()

    # Print the result of fire per month in csv file
    data2.to_csv("C:\\Users\\Owner\\Desktop\\Project_Fire\\Fires_Per_Month.csv")
    fire2Causes.rename(columns={'INC_Name': 'Cause Count'}, inplace=True)

    # Print the result of cause of fire in csv file
    fire2Causes.to_csv("C:\\Users\\Owner\\Desktop\\Project_Fire\\Causes.csv")
    print(fire2Causes)

    #fire2Causes.plot(x="Cause", y=["Cause Count"], kind="line", figsize=(7, 7))
    #plt.show()

    print("Done with File 2!")


if __name__ == "__main__":
    main()

