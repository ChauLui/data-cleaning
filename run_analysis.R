# 
# Source: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article.
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
# A full description is available at the site where the data was obtained:
# 
#       http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
# 
#       https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for
#    each activity and each subject.
# Good luck!
# 




# rm(list=ls())
# 
# setwd("c:/WorkingR/CleaningDataWeek4/Project")
# 
# 
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 
# if(!file.exists("data")) {dir.create("data")}
# 
# download.file(fileUrl, destfile = file.path("data", "getdata-projectfiles-UCI HAR Dataset.zip"))
# 
# unzip(zipfile=file.path("data", "getdata-projectfiles-UCI HAR Dataset.zip"),exdir="data")



# Once unzipped, the folder and file location are as structured:
#       
# data/
#     activity_labels.txt
#     features.txt
#     features_info.txt
#     README.txt

# data/UCI HAR Dataset/train/
#     subject_train.txt 
#     X_train.txt
#     y_train.txt
# data/UCI HAR Dataset/train/Inertial Signals (not used)
# 
# data/UCI HAR Dataset/test/
#     subject_test.txt 
#     X_test.txt
#     y_test.txt
# data/UCI HAR Dataset/test/Inertial Signals (not used)

# "features_info.txt" is like README.txt with a general explanation of the 561 columns in the 'X'files
# "features.txt" is the detail name of each column in the 'X'files
# X_train.txt and X_test.txt contains the measurements of the features
# y_train.txt and y_test.txt contains the activities of each X line.


# Function to combine the files of the person (subject) to the activities and the activity features' measurements.
# Only the measurements on the mean and standard deviation for each measurement are selected.
# The activity feature's measurements are stacked (melt) to make it a narrow data set.


combineFiles <- function(fileSet){
      
      fileLocation <- file.path("data","UCI HAR Dataset", fileSet)
      subjectFileName <- paste("subject_", fileSet,".txt", sep="")
      
      subjectTxt<- read.table(file.path(fileLocation, subjectFileName))

      names(subjectTxt) <- c("subjectNum")

      # create a row ID column in case rows get re-arranged. src and ID columns will be used in merge.
      subjectTxt<- dplyr::mutate(subjectTxt, ID = as.numeric(rownames(subjectTxt), src = fileSet))

      Xtxt <- read.table(file.path(fileLocation, paste("X_", fileSet,".txt", sep="")), stringsAsFactors=FALSE)

      # Extracts only the measurements on the mean and standard deviation for each measurement
      reqCols <- grep("[Mm]ean|[Ss]td", features$featureName)

      selXtxt <- dplyr::select(Xtxt, reqCols)
      # rm(Xtxt)
      selXtxt <- dplyr::mutate(selXtxt, ID = as.numeric(rownames(selXtxt)), src = fileSet)

      yTxt <- read.table(file.path(fileLocation, paste("y_", fileSet,".txt", sep="")))
      names(yTxt) <- c("activityCode")
      yTxt <- dplyr::mutate(yTxt, ID = as.numeric(rownames(yTxt)), src = fileSet)

      yTxt <- merge(yTxt, activityLabels)

      selXtxt <- merge(selXtxt, yTxt)
      selXtxt <- merge(selXtxt, subjectTxt)

      # change from wide to narrow data frame
      XtxtGather <- tidyr::gather(selXtxt, feature, featureValue, -(c(ID, src, activityCode, activityName, subjectNum)))
      return(XtxtGather)

}


fileLocation <- file.path("data","UCI HAR Dataset")

# rename the default column names: V1, V2
features <- read.table(file.path(fileLocation,"features.txt"))
names(features) <- c("featureCode", "featureName")

activityLabels <- read.table(file.path(fileLocation,"activity_labels.txt"))
names(activityLabels) <- c("activityCode", "activityName")
#rem activityLabels <- dplyr::rename(activityLabels, activityCode = V1, activityName = V2)

# call the function to combine the subject, X, y files together.
trainSet <- combineFiles("train")
testSet <- combineFiles("test")

# stack the 'train' data set and the 'test' dataset on top of each other
wholeDataSet <- dplyr::bind_rows(trainSet,testSet)

# remove the 'V' prefix of the original default column names generated during the read.table import process.
# the featureID column is the numeric part that will match up to the features.txt rownames 'featureCode' column.
wholeDataSet <- tidyr::separate(wholeDataSet,feature, c("V","featureID"), sep=1)

# discard column 'V' - a byproduct of the 'separate' function
wholeDataSet$V <- NULL

# convert featureID char type to numeric
wholeDataSet <- dplyr::mutate(wholeDataSet, featureID = as.numeric(featureID))

wholeDataSet <- merge(wholeDataSet, features, by.x = "featureID", by.y = "featureCode") 


BySubjectActivityFeature <- dplyr::group_by(wholeDataSet, subjectNum, activityName, featureName)

BySubjectActivityFeatureAvg <- dplyr::summarize(BySubjectActivityFeature, featureAvg = mean(featureValue))

# write.table(BySubjectActivityFeatureAvg,file="c:/WorkingR/CleaningDataWeek4/Project/AvgFeatureValues.txt", row.names = FALSE)
