library(dplyr)

# Downlaod Datasets

fileZip <- "getdata_projectfiles_UCI HAR Dataset.zip"

# Check if zip file is already downloaded
if(!file.exists(fileZip)){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, fileZip)
}

# Checking if zip file was unzipped and folder exists
if (!file.exists("UCI HAR Dataset")) { 
    unzip(fileZip) 
}

# Reading data
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_code", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "activity_code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectId")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "activity_code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectId")

# 1. Merges the training and the test sets to create one data set

X <- rbind(x_train, x_test)
rm(x_train, x_test)
Y <- rbind(y_train, y_test)
rm(y_train, y_test)
subjects <- rbind(subject_train, subject_test)
rm(subject_train, subject_test)
merged_data <- cbind(subjects, Y, X)
rm(subjects, Y, X)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_sd_data <- merged_data %>% select(subjectId, activity_code, contains("mean"), contains("std"))
rm(merged_data)

# 3. Uses descriptive activity names to name the activities in the data set
mean_sd_data$activity_code <- activities[mean_sd_data$activity_code, 2]

# 4. Appropriately labels the data set with descriptive variable names. 

names(mean_sd_data)[2] <- "activity"
names(mean_sd_data) <- gsub("Acc", "Accelerometer", names(mean_sd_data))
names(mean_sd_data) <- gsub("Gyro", "Gyroscope", names(mean_sd_data))
names(mean_sd_data) <- gsub("BodyBody", "Body", names(mean_sd_data))
names(mean_sd_data) <- gsub("mean", "Mean", names(mean_sd_data), ignore.case = TRUE)
names(mean_sd_data) <- gsub("std", "Std", names(mean_sd_data), ignore.case = TRUE)
names(mean_sd_data) <- gsub("freq", "Frequency", names(mean_sd_data), ignore.case = TRUE)
names(mean_sd_data) <- gsub("angle", "Angle", names(mean_sd_data))
names(mean_sd_data) <- gsub("gravity", "Gravity", names(mean_sd_data))
names(mean_sd_data) <- gsub("Mag", "Magnitude", names(mean_sd_data))
names(mean_sd_data) <- gsub("^t", "Time", names(mean_sd_data))
names(mean_sd_data) <- gsub("^f", "Frequency", names(mean_sd_data))
names(mean_sd_data) <- gsub("\\.", "", names(mean_sd_data))
names(mean_sd_data) <- gsub("[Xx]$", "_X", names(mean_sd_data))
names(mean_sd_data) <- gsub("[Yy]$", "_Y", names(mean_sd_data))
names(mean_sd_data) <- gsub("[Zz]$", "_Z", names(mean_sd_data))

# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
tidyData <- mean_sd_data %>% group_by(activity, subjectId) %>% 
    summarise_all(mean)
write.table(tidyData, "TidyData.txt", row.name=FALSE)
