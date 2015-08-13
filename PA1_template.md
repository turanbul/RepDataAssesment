#Assignment Repreducible Research Case 1
author: "Turan Bulmus"      
date: "Thursday, August 13, 2015"       
output: html_document      

##Loading and preprocessing the data

First, I will load the data that I have forked from repository [RepData_PeerAssessment1](https://github.com/rdpeng/RepData_PeerAssessment1) at GitHub.
```{r, echo=TRUE}
data=read.csv(unz("C:/Users/Turan/coursera/RepData_PeerAssessment1/activity.zip","activity.csv"),header = TRUE,na.strings = "NA")
```
##What is mean total number of steps taken per day?
1. Calculate the total number of steps taken per day
```{r,echo=TRUE,warning=FALSE}
library(dplyr)
by_date=group_by(data,date)
aggregated=summarise(by_date,sum=sum(steps,na.rm = TRUE),mean=mean(steps,na.rm = TRUE),median=median(steps,na.rm=TRUE))
```
2.Make a histogram of the total number of steps taken each day
```{r,echo=TRUE,warning=FALSE}
hist(aggregated$sum,xlab = "Steps",main = "Total of steps taken per day")
```


I will combine "date" and "interval" variables to have one variable indicating the time using lubridate library.
```{r,echo=TRUE}
data$interval=format(round(data$interval/100, 2), nsmall = 2)
data$compdate=paste(data$date,data$interval)

library(lubridate)
data$compdate=strptime(data$compdate,"%Y-%m-%d %k.%M")
```
