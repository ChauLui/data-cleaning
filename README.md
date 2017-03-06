# data-cleaning

Accelerometers data and activities from Coursera data cleaning course.

The data linked from the course's website represents data collected from the accelerometers of the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained:
	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


R script called run_analysis.R contains the following:

A function 'combineFiles' to combine the files of the person (subject) to the activities and the activity features' measurements.
Only the measurements on the mean and standard deviation for each measurement are selected.
The activity feature's measurements are stacked (melt) to make it a narrow data set.

The combineFiles function is called twice, first with the 'train'ing data set and second with the 'test' data set.

The two data sets are pooled together into one set.

The measurement names (features) are populated based on the original 'X' text file column position and the "features.txt" file.

Create a new dataset by grouping the resulting file by the subjectNum, activityName, and featureName and take the mean of each measurement.

