##### SETTING UP #####

## Load libraries
library(tidyverse)
library(openxlsx)
library(ggplot2)
library(psych)
library(nortest)
library(dplyr)
library(ggplot2)
library(qqplotr)
library(lubridate)
library(tidyr)
library(gridExtra)





##### LOADING IN THE DATA #####

## Set working directory
setwd("~/Documents/DS4002/Data")

## Load in csv file
taxi_df <- read.csv('taxi_tripdata.csv')





##### Extracting necessary information from raw data ######

## extract only the pickup date and time column from the raw data set and rename it
taxi_df_pickup <- as.data.frame(taxi_df[,c("lpep_pickup_datetime")])
colnames(taxi_df_pickup) <- c("DateTime")

## convert the DateTime column from character type to datetime type
taxi_df_pickup$DateTime <- as.POSIXct(taxi_df_pickup$DateTime,tz=Sys.timezone())

## create a date column and an hour column from the DateTime column
taxi_df_pickup$Hour <- format(taxi_df_pickup$DateTime, format = "%H")
taxi_df_pickup$Date <- as.Date(format(taxi_df_pickup$DateTime, format = "%Y/%m/%d"))

## find the day of the week from the date using the wday function of the lubridate library
taxi_df_pickup$DayOfWeek <- wday(taxi_df_pickup$Date, label=TRUE)

## order the data by ascending data and find the first and last date of the data set
taxi_df_pickup <- taxi_df_pickup[with(taxi_df_pickup, order(DateTime)),]
# first date is December 31st, 2008 and the last date is August 1st, 2021. It also looks like all hours for all dates of July 2021 are accounted for, so we do not need to remove any. 

## remove dates not in July 2021 and July 5
taxi_df_pickup <- taxi_df_pickup[(taxi_df_pickup$Date>="2021-07-01") & (taxi_df_pickup$Date<="2021-07-31"),]
taxi_df_pickup <- taxi_df_pickup[(taxi_df_pickup$Date != "2021-07-05"),]

## remove weekend days
taxi_df_pickup <- taxi_df_pickup[(taxi_df_pickup$DayOfWeek != "Sat") & (taxi_df_pickup$DayOfWeek != "Sun"), ]







##### Transforming the data to prepare for statistical analysis #####

## create a column that combines the date and hour so we can count up how many pickups there were for each hour of each day
taxi_df_pickup$DateAndHour <- paste(taxi_df_pickup$Date, taxi_df_pickup$Hour)

## count up how many pickups there were for each hour of each day
pickup_counts_df <- as.data.frame(table(taxi_df_pickup$DateAndHour))
colnames(pickup_counts_df) <- c("DateHour", "NumOfPickups")

## indicate whether each row is apart of rush hour or not
# source: https://www.marsja.se/r-add-column-to-dataframe-based-on-other-columns-conditions-dplyr/
pickup_counts_df$DateHour <- as.character(pickup_counts_df$DateHour)
pickup_counts_df <- pickup_counts_df %>% 
  mutate(Type = case_when(
    endsWith(DateHour, "00") ~ "Non Rush Hour",
    endsWith(DateHour, "01") ~ "Non Rush Hour",
    endsWith(DateHour, "02") ~ "Non Rush Hour",
    endsWith(DateHour, "03") ~ "Non Rush Hour",
    endsWith(DateHour, "04") ~ "Non Rush Hour",
    endsWith(DateHour, "05") ~ "Non Rush Hour",
    endsWith(DateHour, "06") ~ "Non Rush Hour",
    endsWith(DateHour, "07") ~ "Rush Hour",
    endsWith(DateHour, "08") ~ "Rush Hour",
    endsWith(DateHour, "09") ~ "Rush Hour",
    endsWith(DateHour, "10") ~ "Non Rush Hour",
    endsWith(DateHour, "11") ~ "Non Rush Hour",
    endsWith(DateHour, "12") ~ "Non Rush Hour",
    endsWith(DateHour, "13") ~ "Non Rush Hour",
    endsWith(DateHour, "14") ~ "Non Rush Hour",
    endsWith(DateHour, "15") ~ "Non Rush Hour",
    endsWith(DateHour, "16") ~ "Rush Hour",
    endsWith(DateHour, "17") ~ "Rush Hour",
    endsWith(DateHour, "18") ~ "Rush Hour",
    endsWith(DateHour, "19") ~ "Non Rush Hour",
    endsWith(DateHour, "20") ~ "Non Rush Hour",
    endsWith(DateHour, "21") ~ "Non Rush Hour",
    endsWith(DateHour, "22") ~ "Non Rush Hour",
    endsWith(DateHour, "23") ~ "Non Rush Hour",
  ))

## find average number of pickups for rush hour hours and non rush hour hours for each day
# source: https://stackoverflow.com/questions/54739757/summing-up-values-in-one-column-based-on-unique-values-in-another-column
pickup_counts_df$DateAndType <- paste(as.Date(pickup_counts_df$DateHour), pickup_counts_df$Type)

EachDayAverage_df <- pickup_counts_df %>%
  group_by(DateAndType) %>%
  mutate(TotalPickups = sum(NumOfPickups), TotalHours = length(NumOfPickups))

EachDayAverage_df <- EachDayAverage_df[!duplicated(EachDayAverage_df$DateAndType), ]
EachDayAverage_df$AveragePickups <- EachDayAverage_df$TotalPickups/EachDayAverage_df$TotalHours

## Extract only the date, the hour type, and the average pickups per hour
final_df <- data.frame(as.Date(EachDayAverage_df$DateHour), EachDayAverage_df$Type, EachDayAverage_df$AveragePickups)
colnames(final_df) <- c("Date", "Type", "AveragePickupsPerHour")






##### Perform statistical analysis #####

## Graph histograms for rush hour and non rush hour populations to see if the distributions are normal
final_df$Date <- as.character(final_df$Date)

par(mfrow=c(1,2))

p1 <- hist(final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour, plot=FALSE) 
P1 <- plot(p1, xlab='Average Number of Pickups', ylab='Frequency', 
     main='Average Number of Pickups by Day During Non Rush Hour Times', col='blue', cex.main=0.5) # Not normal

p2 <- hist(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour, plot=FALSE) 
P2 <- plot(p2, xlab='Average Number of Pickups', ylab='Frequency', 
     main='Average Number of Pickups by Day During Rush Hour Times', col='red', cex.main=0.5) # Not normal

# distributions are not normal so we will have to run a non parametric test to see if centers of populations are the same or not

## Display the means and medians of the two populations for comparison
final_table <- as.data.frame(cbind(Means = c(mean(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour), mean(final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour)), Medians = c(median(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour), median(final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour)), Type = c("Rush Hour", "Non Rush Hour")))
final_table

#It looks as if the mean and the median for rush hour hours is higher than that of non rush hour hours. Is it double though?

## Run a non parametric test (Mann-Whitney-Wilcox Test) to see if the median for rush hour hours is higher than that of non rush hour hours
# source: https://www.statology.org/mann-whitney-u-test-r/
wilcox.test(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour, final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour, alternative="greater")

# p-value is below .05 so we reject the null hypothesis that the median of the two populations are the same. We know that the median for rush hour hours is significantly higher, but is it double?

## Let's see if the mean for rush hour hours is double that of non rush hour hours

## First, turn long data set into wide
# source: https://stackoverflow.com/questions/5890584/how-to-reshape-data-from-long-to-wide-format
final_df_wide <- spread(final_df, key = Type, value = AveragePickupsPerHour)

## Let's find the ratio of average pickups for rush hour:average pickups for non rush hour for each day of the data set
final_df_wide$ratio <- final_df_wide$`Rush Hour` / final_df_wide$`Non Rush Hour`

## Graph the ratios
par(mfrow=c(1,1))

p3 <- hist(final_df_wide$ratio, plot=FALSE) 
P3 <- plot(p3, xlab='Ratios', ylab='Frequency', 
           main='Ratio of Avg Num of Pickups During Rush Hour to Avg Num of Pickups During Non Rush Hour', col='blue', cex.main=0.5) # Not normal

# The distribution is normal so we can run a parametric test

## Run a one sample t-test to see if the ratio is equal to 2 indicating rush hour pickups are double that of non rush hour pickups
t.test(final_df_wide$ratio, mu = 2, alternative = "two.sided")

# p-value is less then .05 so we reject the null hypothesis that the ratio is 2. So what is it? It seems to be less as seen by our graph. 

## Let's see if the ratio is equal to 1.8
t.test(final_df_wide$ratio, mu = 1.8, alternative = "two.sided")

# p-value is 0.5942 so we do not reject the null hypothesis that our ratio is about 1.8. So it looks like the number of pickups during rush hour is about 1.8 of that during non rush hour, so not quite double. 







##### Further Data Visualizations #####

## Display the means and the medians of rush hour and non rush hour
mean_RH <- mean(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour)
mean_NRH <- mean(final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour)
means <- c(RushHour = mean_RH, NonRushHour = mean_NRH)

median_RH <- median(final_df[final_df$Type == 'Rush Hour',]$AveragePickupsPerHour)
median_NRH <- median(final_df[final_df$Type == 'Non Rush Hour',]$AveragePickupsPerHour)
medians <- c(RushHour = median_RH, NonRushHour = median_NRH)

par(mfrow=c(1,2))
p4 <- barplot(means, main="Mean Pickups Per Hour", col=c("darkblue","red"))
p5 <- barplot(medians, main="Median Pickups Per Hour", col=c("darkblue","red"))


## Most other graphics are displayed throughout the analysis. More may be created during M4. 
