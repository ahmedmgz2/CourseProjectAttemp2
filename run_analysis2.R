# libraries needed readr, dplyr, tidyr
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
# Merges the training and the test sets to create one data set.
# 1. create temp dir to store big files
project_temp <- tempdir()
if(!dir.exists(project_temp)){
    dir.create(project_temp)
}

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_arch <- paste0(project_temp, "\\data.zip")
download.file(data_url, destfile = data_arch)
unzip(data_arch, exdir = project_temp, junkpaths = T)



# Read files of concern as data tables
features <- readr::read_table(
    paste0(project_temp,"//features.txt"),
    col_names = c("num", "feat"),
    col_types = "ic")
activities <- readr::read_table(
    paste0(project_temp,"//activity_labels.txt"),
    col_names = c("num", "activity"),
    col_types = "ic")
subject_test <- read_table(
    paste0(project_temp,"//subject_test.txt"),
    col_names = c("subject"),
    col_types = "i")
subject_train <- read_table(
    paste0(project_temp,"//subject_train.txt"),
    col_names = c("subject"),
    col_types = "i")
x_test <- read_table(
    paste0(project_temp,"//X_test.txt"),
    col_names = features$feat)
x_train <- read_table(
    paste0(project_temp,"//X_train.txt"),
    col_names = features$feat)
y_test <- read_table(
    paste0(project_temp,"//y_test.txt"),
    col_names = "code")
y_train <- read_table(
    paste0(project_temp,"//y_train.txt"),
    col_names = "code")

# (the training and the test sets)
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)





# Extracts only the measurements on the mean and standard deviation for each measurement.
td <- Merged_Data %>%
    select(subject, code, contains("mean"), contains("std"))







# Uses descriptive activity names to name the activities in the data set
td <- as_tibble(td)
td$code <- activities[td$code, 2]



# Appropriately labels the data set with descriptive variable names.
names(td)[2] = "activity"
names(td)<-gsub("Acc", "Accelerometer", names(td))
names(td)<-gsub("Gyro", "Gyroscope", names(td))
names(td)<-gsub("BodyBody", "Body", names(td))
names(td)<-gsub("Mag", "Magnitude", names(td))
names(td)<-gsub("^t", "Time", names(td))
names(td)<-gsub("^f", "Frequency", names(td))
names(td)<-gsub("tBody", "TimeBody", names(td))
names(td)<-gsub("-mean()", "Mean", names(td), ignore.case = TRUE)
names(td)<-gsub("-std()", "STD", names(td), ignore.case = TRUE)
names(td)<-gsub("-freq()", "Frequency", names(td), ignore.case = TRUE)
names(td)<-gsub("angle", "Angle", names(td))
names(td)<-gsub("gravity", "Gravity", names(td))







# From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
summary_data <- td %>%
    group_by(subject, activity) %>%
    summarise_all(list(mean))
write.table(summary_data, "summary_data.txt", row.names = F )





# remove data
unlink(project_temp, recursive = T, force = T)
file.remove(project_temp, recursive = T)
rm(list = ls())
unloadNamespace("tidyr")
unloadNamespace("readr")
unloadNamespace("dplyr")
unloadNamespace("tibble")

