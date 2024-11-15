###Load the necessary libraries:

library(dplyr)
library(tidyr)
library(data.table)

###Download and unzip the data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI_HAR_Dataset.zip")
unzip("UCI_HAR_Dataset.zip")

###Read the training and test data

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

###Merge the training and test datasets

X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

###Load the features and activity labels

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

###Label the columns appropriately

names(X) <- features$V2
names(subject) <- "subject"
names(y) <- "activity"

###Extract only mean and standard deviation measurements

mean_std_cols <- grep("mean\\(\\)|std\\(\\)", features$V2)
X <- X[, mean_std_cols]

###Descriptive activity names

y$activity <- factor(y$activity, levels = activity_labels$V1, labels = activity_labels$V2)

###Combine all data into one dataset

data <- cbind(subject, y, X)

###Create a tidy dataset with averages

tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

###Save the tidy dataset

write.table(tidy_data, "tidy_data.txt", row.name = FALSE)
