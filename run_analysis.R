library(data.table)

#load activity labels and change the labels from factor to character
activityLabels <- read.table("UCI_HAR_Dataset/activity_labels.txt")
activityLabels[,2] = as.character(activityLabels[,2])

#load features and change labels from factor to character
features <- read.table("UCI_HAR_Dataset/features.txt")
features[,2] = as.character(features[,2])


#load training sets
trainDat <- read.table("UCI_HAR_Dataset/X_train.txt")
trainAct <- read.table("UCI_HAR_Dataset/train/Y_train.txt")
trainSub <- read.table("UCI_HAR_Dataset/train/subject_train.txt")

#create one data set for train w/subject, activity, and data
train <- cbind(trainSub, trainAct, trainDat)

#load test sets
testDat <- read.table("UCI_HAR_Dataset/test/X_test.txt")
testAct <- read.table("UCI_HAR_Dataset/test/Y_test.txt")
testSub <- read.table("UCI_HAR_Dataset/test/subject_test.txt")

#create one data set for test records w/subject, activity, and data
test <- cbind(testSub, testAct, testDat)


#Merges the training and the test sets to create one data set.
combDat <- rbind(train, test)


#Extracts only the measurements on the mean and standard deviation for each measurement.

#get row numbers for features containing "mean" or "std" anywhere in the feature name
  #also remove parens in name
usedFeatures <- grep(".*mean.*|.*std.*", features[,2])
usedFeatures.names <- gsub('[()]', '', usedFeatures.names)

combDat <- combDat[,usedFeatures]

#Appropriately labels the data set with descriptive variable names.
colnames(combDat) <- c("Subject", "Activity", usedFeatures.names)

#Uses descriptive activity names to name the activities in the data set
  #make activity into a factor
combDat$Activity <- factor(combDat$Activity, levels = activityLabels[,1], labels = activityLabels[,2])


#From the data set in step 4, creates a second, independent tidy data set with the 
  #average of each variable for each activity and each subject and write it to a file.
dt <- data.table(combDat)
meandat <- dt[, lapply(.SD, mean), by=list(Subject, Activity)]
write.table(meandat, file="meandat.txt")
