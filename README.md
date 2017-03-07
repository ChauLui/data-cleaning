# data-cleaning

Accelerometers data and activities

Source: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
A full description is available at the site where the data was obtained:

      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



R script called run_analysis.R that does the following.

A function 'combineFiles' to combine the files of the person (subject) to the activities and the activity features' measurements.
Only the measurements on the mean and standard deviation for each measurement are selected.


The combineFiles function is called twice, first with the 'train'ing data set and second with the 'test' data set.

The two data sets are stacked together into one data set.

Add the descriptive activity names to name the activities in the data set.

From the data set creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Output the independent tidy data set to a table.