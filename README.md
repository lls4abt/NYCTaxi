# NYCTaxi

## Contents
This Repository contains three main folders and two additional files. 
- The SRC folder contains the main source code of our analysis
- The DATA folder contains the data used in the analysis as well as documentation about the data
- The FIGURES folder contains all figures produced during our analysis
- The LICENSE.md file explains to a visitor the terms under which they may use and cite this repository
- This README.md file serves as an orientation to this repository. 

## Hypothesis
During the weekdays of July 2021 in New York City, the average amount of taxi pickups during each hour of rush hour (7-9am and 4-6pm) is double the average amount of taxi pickups during each hour of non-rush hour.

## SRC Folder
### Installing/Building Code:
Run this program using R. It is recommended to open the R files in RStudio. Download the R files to your local computer and then open in RStudio to execute. 

### Using Code:
First, download the data (CSV) to your personal computer, as the data will come from your personal directory. One of the first lines of the codes is used to set up your working directory. Change this to match the file path that matches where you saved the data on your local machine. The rest of the code can be run line by line or in totality on RStudio. There are six mains sections to the code file. The sections are clearly segmented in the code file. These sections are as follows: 

1. Setting Up
2. Loading in the data
3. Extracting necessary information from raw data
4. Transforming the data to prepare for statistical analysis
5. Performing the statistical analyses
6. Further Data Visualizations

## DATA Folder
### Data Collection Process:

We obtained the data for our project from Kaggle, but the data itself was orginially sourced from NYCData. Records of the taxi ride information was provided by Creative Mobile Technologies, LLC and VeriFone Inc, payment systems used by Yellow Cabs and Ubers in NYC.

### Data File:
<a href="https://github.com/lls4abt/NYCTaxi/blob/main/DATA/taxi_tripdata.csv">DATA folder</a>

<a href="https://www.kaggle.com/datasets/anandaramg/taxi-trip-data-nyc?resource=download&select=taxi_tripdata.csv">Kaggle link</a>

### Data Dictionary:
DATA folder: https://github.com/lls4abt/NYCTaxi/blob/main/DATA/Data_Dictionaries_&_User_Guide.pdf

### Data Context Narrative:
In order to prove or disprove our hypothesis about taxi pickups during rush hour and non rush hour in New York City, we needed to find a data set with variables that would allow us to test it. We found a data set on Kaggle that included taxi pickup times for dates in July 2021. We assume this data is only a sample of the full population of taxi rides in July 2021 in New York City due to the fact that the maximum average number of pickups for a specific hour is only about 200 pickups whereas there are thousands of taxis in New York City. From our initial data visualization exercises, we did found a large difference between the number of taxi rides during the day vs. during the night as expected; however, we found the difference in taxi pickups during the day hours to be much more even than expected. During the day, we predicted there to be much less pickups during non rush hour hours in comparison to rush hour hours. This might indicate that our hypothesis is false, but we would want to run a statistical analysis to be certain. Understanding the validity of our hypothesis will help us understand if rush hour traffic in NYC is still prominent or if it is a thing of the past. 

## Figures Folder
### 1. PrelimAnalysisFig1:
This bar graph compares the number of taxi rides per day in NYC on weekdays versus the weekend. 

### 2. PrelimAnalysisFig2:
This bar graph shows average hourly taxi rides on weekdays in NYC.

### 3. PrelimAnalysisFig3:
This bar graph shows average hourly taxi rides on weekends in NYC.

### 4. Data flowchart:
A graphic that demonstrates our analysis plan and our next steps, drawn up as of completing MI2.

### 5. AnalysisPlot1:
This set of histograms shows the distribution of average rush hour pickups and average non rush hour pickups per day. This plot was used to see if the distributions were normal or not to decide if a parametirc or non parametric test should be used for further statistical analysis. 

### 6. AnalysisPlot2:
This histogram shows the distribution of the ratios of average rush hour pickups to average non rush hour pickups per day. This plot was used to see if the distribution was normal or not to decide if a parametirc or non parametric test should be used for further statistical analysis.

### 7. AnalysisPlot3:
This plot compares the means and medians for average pickups per hour for non rush hour hours and rush hour hours. 


## References

### Prepatory Assignments: 
<a href="https://github.com/lls4abt/NYCTaxi/MI1.Hypothesis.pdf">M1: Hypothesis</a> <br>
<a href="https://github.com/lls4abt/NYCTaxi/files/9620517/M2.pdf">M2: Establish Data</a>

### Acknowledgements: 
Thanks to Professor Alonzi for his guidance, wisdom, and inspiration and thanks to Harsh for his expertise each step of the way. <br>
The biggest shoutout to Mayor Bloomberg for the gracious time and effort he put in to promoting NYC Open Data. 

### References: 
[1] H. Law, “Safety Tips for rush hour traffic,” Heintz Law, 19-Dec-2019. [Online]. Available: https://www.heintzlaw.com/tips-for-rush-hour-traffic/. [Accessed: 09-Sep-2022]. <br>
[2] J. S. Russell, “Can Rush Hour Be Banished?,” Bloomberg, 25-Aug-2021. [Online]. Available: https://www.bloomberg.com/news/articles/2021-08-25/despite-remote-work-rush-hour-returned. [Accessed: 07-Sep-2022]. <br>
[3] NYC Taxi & Limousine Commission, “TLC Trip Record Data.”[Online]. Available: https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page. [Accessed: 14-Sep-2022]. 

