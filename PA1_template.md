#Assignment Repreducible Research Case 1
author: "Turan Bulmus"      
date: "Sunday, August 16, 2015"       
output: html_document      

##Loading and preprocessing the data

First, I will load the data that I have forked from repository [RepData_PeerAssessment1](https://github.com/rdpeng/RepData_PeerAssessment1) at GitHub.

```r
data=read.csv(unz("C:/Users/Turan/coursera/RepData_PeerAssessment1/activity.zip","activity.csv"),header = TRUE,na.strings = "NA")
```
##What is mean total number of steps taken per day?
1. **Calculate the total number of steps taken per day**

```r
suppressPackageStartupMessages(library(dplyr))
by_date=group_by(data,date)
aggregated=summarise(by_date,sum=sum(steps,na.rm = TRUE),mean=mean(steps,na.rm = TRUE),median=median(steps,na.rm=TRUE))
```
2. **Make a histogram of the total number of steps taken each day**

```r
hist(aggregated$sum,xlab = "Steps",main = "Total steps taken per day")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

3. **Calculate and report the mean and median of the total number of steps taken per day**

```r
aggregated[,c(1,3,4)]
```

```
## Source: local data frame [61 x 3]
## 
##          date     mean median
## 1  2012-10-01      NaN     NA
## 2  2012-10-02  0.43750      0
## 3  2012-10-03 39.41667      0
## 4  2012-10-04 42.06944      0
## 5  2012-10-05 46.15972      0
## 6  2012-10-06 53.54167      0
## 7  2012-10-07 38.24653      0
## 8  2012-10-08      NaN     NA
## 9  2012-10-09 44.48264      0
## 10 2012-10-10 34.37500      0
## ..        ...      ...    ...
```

##What is the average daily activity pattern?
1. **Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)**  
For this part I merge the data "aggregated" back to the initial data frame "data"


```r
data=left_join(data,aggregated)
```

```
## Joining by: "date"
```
Next I will create an extra variable combining the "interval" and "date" variables to have one variable indicating the time using lubridate library and present the first six rows of the joined variable "compdate".

```r
data$interval=format(round(data$interval/100, 2), nsmall = 2)
data$compdate=paste(data$date,data$interval)

library(lubridate)
data$compdate=strptime(data$compdate,"%Y-%m-%d %k.%M")
head(data$compdate)
```

```
## [1] "2012-10-01 00:00:00 CEST" "2012-10-01 00:05:00 CEST"
## [3] "2012-10-01 00:10:00 CEST" "2012-10-01 00:15:00 CEST"
## [5] "2012-10-01 00:20:00 CEST" "2012-10-01 00:25:00 CEST"
```
Finally I will make the plot by using the plot function

```r
plot(x=data$compdate,y=data$mean,type="l")
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

2. **Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?**


```r
data[max(data$steps,na.rm=TRUE),]
```

```
##     steps       date interval   sum     mean median            compdate
## 806    41 2012-10-03    19.05 11352 39.41667      0 2012-10-03 19:05:00
```
##Imputing missing values
1. **Calculate and report the total number of missing values in the dataset**

```r
sum(is.na(data$steps))
```

```
## [1] 2304
```
2. **Devise a strategy for filling in all of the missing values in the dataset.**  
Since the strategy need not to be sophisticated, I replaced all the missing values with zero as NA already hints no steps were taken at the time invterval. I also count the number of missing values after imputation. The code used is as follows:

```r
data[is.na(data[,1]), 1] =0
sum(is.na(data$steps))
```

```
## [1] 0
```
3. **Create a new dataset that is equal to the original dataset but with the missing data filled in.**  
In Step 2, the database is already created.  
4. **Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.  **

```r
data2=data[,c(1,2)]
by_date2=group_by(data2,date)
aggregated2=summarise(by_date2,sum=sum(steps,na.rm = TRUE),mean=mean(steps,na.rm = TRUE),median=median(steps,na.rm=TRUE))
hist(aggregated2$sum,xlab = "Steps",main = "Total steps taken per day after Imputation")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

Note that the histogram is not different from the earlier histogram as missing values are replaced with 0 not changing the daily total steps. From this perspective imputing missing values have no effect on the data set except the NaNs are replaced with 0.  
Finally the mean and the median total number of steps taken per day is as follows:

```r
aggregated2[,c(1,3,4)]
```

```
## Source: local data frame [61 x 3]
## 
##          date     mean median
## 1  2012-10-01  0.00000      0
## 2  2012-10-02  0.43750      0
## 3  2012-10-03 39.41667      0
## 4  2012-10-04 42.06944      0
## 5  2012-10-05 46.15972      0
## 6  2012-10-06 53.54167      0
## 7  2012-10-07 38.24653      0
## 8  2012-10-08  0.00000      0
## 9  2012-10-09 44.48264      0
## 10 2012-10-10 34.37500      0
## ..        ...      ...    ...
```
##Are there differences in activity patterns between weekdays and weekends?   
1. **Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.**

```r
suppressPackageStartupMessages(library(chron))
aggregated2=mutate(aggregated2,week=ifelse(is.weekend(date),"Weekend","Weekday"))
```

2. **Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). **  
