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
#     subject_train.txt (7,352 rows)
#     X_train.txt
#     y_train.txt
# data/UCI HAR Dataset/train/Inertial Signals (not used)
# 
# data/UCI HAR Dataset/test/
#     subject_test.txt  (2,947 rows)
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
      
      # read in the 'Subject' table
      subjectFileName <- paste("subject_", fileSet,".txt", sep="")
      
      subjectTxt<- read.table(file.path(fileLocation, subjectFileName))

      names(subjectTxt) <- c("subjectNum")
      
      # read in the 'X' table - measurements
      Xtxt <- read.table(file.path(fileLocation, paste("X_", fileSet,".txt", sep="")), stringsAsFactors=FALSE)

      # Instruction Step 2. Extracts only the measurements on the mean and standard deviation for each measurement
      reqCols <- grep("mean|std", features$featureName)

      selXtxt <- dplyr::select(Xtxt, reqCols)
      
      # Instruction Step 4. Appropriately labels the data set with descriptive variable names.
      # rename the V1, V2, V3 ... column names to the feature names.
      names(selXtxt) <- features[reqCols, 2]

      # Read in the 'y' table - activities
      yTxt <- read.table(file.path(fileLocation, paste("y_", fileSet,".txt", sep="")))
      names(yTxt) <- c("activityCode")

      # combine the three files
      selXtxt <- cbind(selXtxt, yTxt, subjectTxt)
      
      return(selXtxt)

}


fileLocation <- file.path("data","UCI HAR Dataset")

# rename the default column names: V1, V2
features <- read.table(file.path(fileLocation,"features.txt"))
names(features) <- c("featureCode", "featureName")

activityLabels <- read.table(file.path(fileLocation,"activity_labels.txt"))
names(activityLabels) <- c("activityCode", "activityName")


# call the function to combine the subject, X, y files together.
trainSet <- combineFiles("train")
testSet <- combineFiles("test")

# Instruction Step 1. Merges the training and the test sets to create one data set.
wholeDataSet <- dplyr::bind_rows(trainSet,testSet)

# Instruction Step 3. Uses descriptive activity names to name the activities in the data set
wholeDataSet <- merge(wholeDataSet, activityLabels)

# remove the activityCode column
wholeDataSet$activityCode <- NULL

# Instruction Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for
#    each activity and each subject.
BySubjectActivityAvg <- aggregate(wholeDataSet[,1:79], list(subjectNum=wholeDataSet$subjectNum,activityName=wholeDataSet$activityName), mean)

# output final data set
write.table(BySubjectActivityAvg,file="c:/WorkingR/CleaningDataWeek4/Project/BySubjectActivityAvg.txt", row.names = FALSE)

