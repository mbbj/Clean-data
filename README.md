Getting and Cleaning Data Course Project

Background: One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

Run_analysis.R does the following:

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data setAppropriately labels the data set with descriptive variable names. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

How the script works:

Set the directories through file in R

Open the packages data.table and reshape2 and downloade data unzip the file: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


Then we lode the Activity and features files and add columnnames: " activityLabels",
"activityName" and "featureIndex", "featureNames"
For each measurement for the feature we only extracts the ones that include
mean and standard deviations.

We now load and bind train datasets (X_train.txt , Y_train.txt and subject_train.txt) where
we only use the features with mean and std. Additionally we add column names. Cbind
is used to bind the datasets. The same process is done with the test datasets.
We now have a train and a test dataset that we are binding with the rbind in order
to have one dataset. 

From the dataset  we now create a second
independent tidy dataset with average of each variable for each activity and
each subject. We therefore convert activityLabels to activityName etc. and use
reshape2 to reshape the data and then take the average for each variable. The
result is a csv file called "tidyData.csv".
