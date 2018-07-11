setwd("C:\\WorkingR\\CleaningDataWeek3")

# 1. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#       
#       https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#       
#       https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# 
# which(agricultureLogical)
# 
# What are the first 3 values that result?
# 
# 153 ,236, 388
# 
# 236, 238, 262
# 
# 125, 238,262  This is it!
# 
# 59, 460, 474




download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", destfile = "C:\\WorkingR\\CleaningDataWeek3\\ACSIdaho.csv")

# trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
# Content type 'text/csv' length 4246554 bytes (4.0 MB)
# downloaded 4.0 MB
ACSData <-read.csv("C:\\WorkingR\\CleaningDataWeek3\\ACSIdaho.csv")
names(ACSData)
# ACR 1
# Lot size
# b .N/A (GQ/not a one-family house or mobile home)
# 1 .House on less than one acre
# 2 .House on one to less than ten acres
# 3 .House on ten or more acres

# AGS 1
# Sales of Agriculture Products
# b .N/A (less than 1 acre/GQ/vacant/
#               .2 or more units in structure)
# 1 .None
# 2 .$ 1 - $ 999
# 3 .$ 1000 - $ 2499
# 4 .$ 2500 - $ 4999
# 5 .$ 5000 - $ 9999
# 6 .$10000+

agricultureLogical <- (ACSData$ACR==3 & ACSData$AGS ==6)
which(agricultureLogical)

# 2. Using the jpeg package read in the following picture of your instructor into R
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)
# 
# -15259150 -10575416 This is it
# 
# -10904118 -10575416
# 
# -15259150 -594524
# 
# -14191406 -10904118

install.packages("jpeg")

# Installing package into 'P:/Chau_Lui/My Documents/R/win-library/3.3'
# (as 'lib' is unspecified)
# trying URL 'https://cran.rstudio.com/bin/windows/contrib/3.3/jpeg_0.1-8.zip'
# Content type 'application/zip' length 227928 bytes (222 KB)
# downloaded 222 KB
# 
# package 'jpeg' successfully unpacked and MD5 sums checked
# 
# The downloaded binary packages are in
# C:\Temp\RtmpsTykjj\downloaded_packages


library(jpeg)
JeffJPEG <- jpeg::readJPEG("https://d396qusza40orc.cloudfront.net/getdata-jeff.jpg", native = TRUE)
# Error in jpeg::readJPEG("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",  : 
#                               unable to open https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

JeffJPEG <- jpeg::readJPEG("getdata%2Fjeff.jpg", native = TRUE)

quantile(JeffJPEG, probs = c(0.30,0.80))
# 
#             30%       80% 
#       -15259150 -10575416 


# 3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#       
#       https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile = "C:\\WorkingR\\CleaningDataWeek3\\getData-data-GDP.csv")

GDPData <-read.csv("C:\\WorkingR\\CleaningDataWeek3\\getData-data-GDP.csv", skip = 4, na.strings = c(""," "))
names(GDPData)
# [1] "X"   "X.1" "X.2" "X.3" "X.4" "X.5" "X.6" "X.7" "X.8" "X.9"

GDPData2 <- dplyr::rename(GDPData,countryCode=X, ranking = X.1,country=X.3, GDPmil = X.4 )
GDPData3 <- dplyr::select(GDPData2, c(countryCode, ranking, country, GDPmil))
GDPDataIndex <- complete.cases(GDPData3)
GDPData5 <- GDPData3[GDPDataIndex,]

GDPData5 <- dplyr::mutate(GDPData5, ranknumeric=as.numeric(ranking))
class(GDPData5$ranking)

# skipNul=TRUE doesn't seem to do any thing
# colClass - 
# > GDPData6 <- read.csv("C:\\WorkingR\\CleaningDataWeek3\\getData-data-GDP.csv", skip = 4, colClasses = classes)
# Error in scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  : 
#   scan() expected 'a real', got '"16'
#GDPData6 <- read.csv("C:\\WorkingR\\CleaningDataWeek3\\getData-data-GDP.csv", stringsAsFactors=FALSE,na.strings = c(""," "), skip = 4, skipNul = TRUE)
GDPDataB <- read.csv("C:\\WorkingR\\CleaningDataWeek3\\getData-data-GDP.csv", stringsAsFactors=FALSE,na.strings = c(""," "), skip = 4)
GDPDataB2 <- dplyr::mutate(GDPDataB, ranking=as.numeric(X.1), GDPmil=as.numeric(gsub(",","",X.4)))
#classes <- sapply(GDPDataB2, class)

GDPDataB2 <- dplyr::rename(GDPDataB2,countryCode=X, country=X.3)

GDPDataB2 <- dplyr::select(GDPDataB2, c(countryCode, ranking, country, GDPmil))
#as.numeric(sub(",", ".", Input, fixed = TRUE))
# read.table("file.txt", dec=",")

GDPDataIndex <- complete.cases(GDPDataB2)
# length(GDPDataIndex)
GDPDataB3 <- GDPDataB2[GDPDataIndex,]
                          
# rm(list=ls())
# trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
# Content type 'text/csv' length 9630 bytes
# downloaded 9630 bytes

# 
# Load the educational data from this data set:
#       
#       https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "C:\\WorkingR\\CleaningDataWeek3\\getData-data-FEDSTATS_Country.csv")

# trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
# Content type 'text/csv' length 59792 bytes (58 KB)
# downloaded 58 KB
EdStatsCtry <- read.csv("C:\\WorkingR\\CleaningDataWeek3\\getData-data-FEDSTATS_Country.csv")    # blank lines automatically excluded
names(EdStatsCtry)

EdStatsCtry2 <- dplyr::select(EdStatsCtry, (CountryCode:Income.Group))
# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
# 
mergedData <- merge(GDPDataB3, EdStatsCtry2, by.x="countryCode", by.y="CountryCode")  # merge() is not part of dplyr!
arrg = dplyr::arrange(mergedData, desc(GDPmil))
str(arrg)

arrg[13,]
# countryCode ranking country  GDPmil        Long.Name      Income.Group
# 13         ESP      13   Spain 1322965 Kingdom of Spain High income: OECD

# Original data sources:
#       
#       http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats
# 
# 234 matches, 13th country is Spain
# 
# 190 matches, 13th country is St. Kitts and Nevis
# 
# 234 matches, 13th country is St. Kitts and Nevis
# 
# 189 matches, 13th country is Spain    ### This was wrong!!
# 
# 189 matches, 13th country is St. Kitts and Nevis
# 
# 190 matches, 13th country is Spain

# 4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

HgInc <- dplyr::group_by(arrg,Income.Group)
dplyr::summarize(HgInc,mean(ranking), median(ranking))
# A tibble: 5 × 3
# Income.Group `mean(ranking)` `median(ranking)`
# <fctr>           <dbl>             <dbl>
#       1 High income: nonOECD        91.91304              94.0
# 2    High income: OECD        32.96667              24.5
# 3           Low income       133.72973             139.0
# 4  Lower middle income       107.70370              99.5
# 5  Upper middle income        92.13333              83.0

# 
# 133.72973, 32.96667
# 
# 23, 30
# 
# 23.966667, 30.91304
# 
# 32.96667, 91.91304
# 
# 30, 37
# 
# 23, 45
# 1
# point
# 5. 
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
# 
# are Lower middle income but among the 38 nations with highest GDP?
# 
# 13
# 
# 5
# 
# 12
# 
# 0
# 

install.packages("Hmisc")

arrgGDP = dplyr::arrange(mergedData, desc(GDPmil))

arrGDPtop38 <- arrgGDP[1:38,]

arrg3 = plyr::mutate(arrGDPtop38,GDPmil5Grp=Hmisc::cut2(GDPmil,g=5))
table(arrg3$GDPmil5Grp, arrg3$Income.Group)

# 
# High income: nonOECD High income: OECD Low income
# [ 262832,  369606) 0                    3                 1          0
# [ 369606,  514060) 0                    0                 4          0
# [ 514060, 1129598) 0                    1                 3          0
# [1129598, 2252664) 0                    0                 5          0
# [2252664,16244600] 0                    0                 5          0
# 
# Lower middle income Upper middle income
# [ 262832,  369606)                   2                   2
# [ 369606,  514060)                   0                   4
# [ 514060, 1129598)                   1                   2
# [1129598, 2252664)                   1                   2
# [2252664,16244600]                   1                   1
str(arrg3)

# arrg2 = plyr::mutate(arrg,ranking5Grp=Hmisc::cut2(ranking,g=5))
# 
# table(arrg2$ranking5Grp, arrg2$Income.Group)
# 
# arrg3 = plyr::mutate(arrg,GDPmil5Grp=Hmisc::cut2(GDPmil,g=5))
# table(arrg3$GDPmil5Grp, arrg3$Income.Group)



