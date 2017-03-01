# data-cleaning

Accelerometers data and activities

Source: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
A full description is available at the site where the data was obtained:

      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Once unzipped, the folder and file location are as structured:

data/
  activity_labels.txt
  features.txt
  features_info.txt
  README.txt
 data/UCI HAR Dataset/train/
      subject_train.txt 
      X_train.txt
      y_train.txt
 data/UCI HAR Dataset/train/Inertial Signals (not used)
 
 data/UCI HAR Dataset/test/
      subject_test.txt 
      X_test.txt
      y_test.txt
 data/UCI HAR Dataset/test/Inertial Signals (not used)

 "features_info.txt" is like README.txt with a general explanation of the 561 columns in the 'X'files
 "features.txt" is the detail name of each column in the 'X'files
 X_train.txt and X_test.txt contains the measurements of the features
 y_train.txt and y_test.txt contains the activities of each X line.

R script called run_analysis.R that does the following.

A function 'combineFiles' to combine the files of the person (subject) to the activities and the activity features' measurements.
Only the measurements on the mean and standard deviation for each measurement are selected.
The activity feature's measurements are stacked (melt) to make it a narrow data set.

The combineFiles function is called twice, first with the 'train'ing data set and second with the 'test' data set.

The two data sets are pooled together into one set.

The measurement names are populated based on the original 'X' text file column position and the "features.txt" file,

