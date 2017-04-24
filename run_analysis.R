#Downloade data
packages <- c("data.table", "reshape2") 
sapply(packages, require, character.only=TRUE, quietly=TRUE) 
path <- getwd() 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(url, file.path(path, "dataFiles.zip")) 
unzip(zipfile = "dataFiles.zip") 

#Add Activity and features columnnames
activityLabels <- fread(file.path(path, "activity_labels.txt"), col.names = c("classLabels", "activityName")) 
features <- fread(file.path(path, "features.txt"), col.names = c("index", "featureNames")) 

# Extracts only mean and standard deviations for each measurement
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames]) 
measurements <- features[featuresWanted, featureNames] 
measurements <- gsub('[()]', '', measurements)

# Load and bind train datasets and add columnnames
train <- fread(file.path(path, "train/X_train.txt"))[, featuresWanted, with = FALSE] 
data.table::setnames(train, colnames(train), measurements) 
trainActivities <- fread(file.path(path, "train/Y_train.txt"), col.names = c("Activity")) 
trainSubjects <- fread(file.path(path, "train/subject_train.txt"), col.names = c("SubjectNum")) 
train <- cbind(trainSubjects, trainActivities, train) 

# Load and bind test datasets and add columnnames
test <- fread(file.path(path, "test/X_test.txt"))[, featuresWanted, with = FALSE] 
data.table::setnames(test, colnames(test), measurements) 
testActivities <- fread(file.path(path, "test/Y_test.txt"), col.names = c("Activity")) 
testSubjects <- fread(file.path(path, "test/subject_test.txt"), col.names = c("SubjectNum")) 
test <- cbind(testSubjects, testActivities, test) 

# merge datasets 
combined <- rbind(train, test) 

 
# Convert classLabels to activityName - tidy data with average for each 
combined[["Activity"]] <- factor(combined[, Activity] 
                              , levels = activityLabels[["classLabels"]] 
                              , labels = activityLabels[["activityName"]]) 

 
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum]) 
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity")) 
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean) 

 
data.table::fwrite(x = combined, file = "tidyData.csv", quote = FALSE) 
