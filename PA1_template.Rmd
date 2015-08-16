#Assignment Repreducible Research Case 1
author: "Turan Bulmus"      
date: "Sunday, August 16, 2015"       
output: html_document      

##Loading and preprocessing the data

First, I will load the data that I have forked from repository [RepData_PeerAssessment1](https://github.com/rdpeng/RepData_PeerAssessment1) at GitHub.
```{r, echo=TRUE}
data=read.csv(unz("C:/Users/Turan/coursera/RepData_PeerAssessment1/activity.zip","activity.csv"),header = TRUE,na.strings = "NA")
```
##What is mean total number of steps taken per day?
1. **Calculate the total number of steps taken per day**
```{r,echo=TRUE,warning=FALSE}
suppressPackageStartupMessages(library(dplyr))
by_date=group_by(data,date)
aggregated=summarise(by_date,sum=sum(steps,na.rm = TRUE),mean=mean(steps,na.rm = TRUE),median=median(steps,na.rm=TRUE))
```
2. **Make a histogram of the total number of steps taken each day**
```{r,echo=TRUE,warning=FALSE}
hist(aggregated$sum,xlab = "Steps",main = "Total steps taken per day")
```

3. **Calculate and report the mean and median of the total number of steps taken per day**
```{r,echo=TRUE}
aggregated[,c(1,3,4)]
```

##What is the average daily activity pattern?
1. **Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)**  
For this part I merge the data "aggregated" back to the initial data frame "data"

```{r,echo=TRUE}
data=left_join(data,aggregated)
```
Next I will create an extra variable combining the "interval" and "date" variables to have one variable indicating the time using lubridate library and present the first six rows of the joined variable "compdate".
```{r,echo=TRUE}
data$interval=format(round(data$interval/100, 2), nsmall = 2)
data$compdate=paste(data$date,data$interval)

library(lubridate)
data$compdate=strptime(data$compdate,"%Y-%m-%d %k.%M")
head(data$compdate)
```
Finally I will make the plot by using the plot function
```{r,echo=TRUE}
plot(x=data$compdate,y=data$mean,type="l")
```  

2. **Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?**

```{r,echo=TRUE}
data[max(data$steps,na.rm=TRUE),]
```
##Imputing missing values
1. **Calculate and report the total number of missing values in the dataset**
```{r,echo=TRUE}
sum(is.na(data$steps))
```
2. **Devise a strategy for filling in all of the missing values in the dataset.**  
Since the strategy need not to be sophisticated, I replaced all the missing values with zero as NA already hints no steps were taken at the time invterval. I also count the number of missing values after imputation. The code used is as follows:
```{r,echo=TRUE}
data[is.na(data[,1]), 1] =0
sum(is.na(data$steps))
```
3. **Create a new dataset that is equal to the original dataset but with the missing data filled in.**  
In Step 2, the database is already created.  
4. **Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.  **
```{r,echo=TRUE}
data2=data[,c(1,2)]
by_date2=group_by(data2,date)
aggregated2=summarise(by_date2,sum=sum(steps,na.rm = TRUE),mean=mean(steps,na.rm = TRUE),median=median(steps,na.rm=TRUE))
hist(aggregated2$sum,xlab = "Steps",main = "Total steps taken per day after Imputation")
```  

Note that the histogram is not different from the earlier histogram as missing values are replaced with 0 not changing the daily total steps. From this perspective imputing missing values have no effect on the data set except the NaNs are replaced with 0.  
Finally the mean and the median total number of steps taken per day is as follows:
```{r,echo=TRUE}
aggregated2[,c(1,3,4)]
```
##Are there differences in activity patterns between weekdays and weekends?   
1. **Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.**
```{r,echo=TRUE}
suppressPackageStartupMessages(library(chron))
aggregated2=mutate(aggregated2,week=ifelse(is.weekend(date),"Weekend","Weekday"))
```   

2. **Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). **  
