library(dplyr)

#Load activity labels and features
activityLabels <- read.table("data/activity_labels.txt")
activityLabels <- read.csv("data/activity_labels.txt", header = F,col.names = c("ActivityNum", "ActivityName"), sep = " ")
activityLabels <- select(activityLabels, ActivityName)
features <- read.table("data/features.txt")
features <- read.csv("data/features.txt", header = F,col.names = c("featureNum", "featureName"), sep = " ")
features <- select(features, featureName)
#Get the wanted features, i.e. mean and standard deviation
featuresWanted <- features[grep("mean\\(\\)|std\\(\\)",features[,1]),]
features %>%  filter(grep("mean"), x=.data)
#Load training datasets
train <- read.table("data/train/X_train.txt")[featuresWanted[,1]]
trainActivities <- read.table("data/train/y_train.txt")
trainSubjects <- read.table("data/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#Load test datasets
test <- read.table("data/test/X_test.txt")[featuresWanted[,1]]
testActivities <- read.table("data/test/y_test.txt")
testSubjects <- read.table("data/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#Merge training and test datasets
merged  <- rbind(train, test)

#Label the merged set
colnames(merged) <- c("Subject", "Activity", featuresWanted[,2])

merged$Activity <- factor(merged$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
merged$subject <- as.factor(merged$Subject)

#Create tidy set with the average of each variable for each activity and each subject
#data_mean <- merged %>% group_by(Activity, Subject) %>% summarize_all(mean, .vars = c(-1,-2,-69) )
data_mean <- merged %>% group_by(Activity, Subject) %>% summarise(across(where(is.numeric), mean))

write.table(data_mean, "tidy_set.txt", row.name=FALSE)
