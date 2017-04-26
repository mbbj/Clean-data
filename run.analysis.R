#Downloade data
packages <- c("data.table", "reshape2") 
sapply(packages, require, character.only=TRUE, quietly=TRUE) 
path <- getwd() 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(url, file.path(path, "dataFiles.zip")) 
unzip(zipfile = "dataFiles.zip") 

#Add Activity and features columnnames
activityLabels <- fread(file.path(path, "activity_labels.txt"), col.names = c("activityLabels", "activityName")) 
features <- fread(file.path(path, "features.txt"), col.names = c("featureIndex", "featureName")) 

# Extracts only mean and standard deviations for each featureName
selectfeatures <- grep("(mean|std)\\(\\)", features[, featureName]) 

#See the selectedfeatures names
selectedfeatureNames <- features[selectfeatures, featureName] 


# Load and bind train datasets and add columnnames
trainX <- fread(file.path(path, "train/X_train.txt"))[, selectfeatures, with = FALSE] 
trainY <- fread(file.path(path, "train/Y_train.txt"), col.names = c("Activity")) 
trainSubject <- fread(file.path(path, "train/subject_train.txt"), col.names = c("Subject")) 
train <- cbind(trainSubject, trainY, trainX) 


# Load and bind test datasets and add columnnames
testX <- fread(file.path(path, "test/X_test.txt"))[, selectfeatures, with = FALSE] 
testY <- fread(file.path(path, "test/Y_test.txt"), col.names = c("Activity")) 
testSubject <- fread(file.path(path, "test/subject_test.txt"), col.names = c("Subject")) 
test <- cbind(testSubject, testY, testX) 

# merge datasets 
combined <- rbind(train, test) 


# Create a second independent tidy dataset with average of each variable for each activity and each subject
# Convert activityLabels to activityName etc. and use reshape2 to reshape the data

combined[["Activity"]] <- factor(combined[, Activity] 
                                 , levels = activityLabels[["activityLabels"]] 
                                 , labels = activityLabels[["activityName"]]) 


combined[["Subject"]] <- as.factor(combined[, Subject]) 
combined <- reshape2::melt(data = combined, id = c("Subject", "Activity")) 
combined <- reshape2::dcast(data = combined, Subject + Activity ~ variable, fun.aggregate = mean) 

#Create tidyData set
data.table::fwrite(x = combined, file = "tidyData.csv", quote = FALSE) 