# Download and unzip file package.
fileurl<- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dest<- '~/data/ucidata.zip'
download.file(fileurl,dest,method='curl')
unzip(dest)

setwd('~/UCI HAR Dataset')

library(plyr)

# 1. Merge the Training and Test Data sets Together

xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

# Create data sets for X, Y and Subject
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind(subjecttrain, subjecttest)

# 2. Only Extract the Measurements on the Mean and Standard Deviation

features <- read.table("features.txt")

# Get Only Columns with 'Mean' or 'Std' in their Names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset the Desired Columns
xdata <- xdata[, mean_std_features]

# Correct the Column Names
names(xdata) <- features[mean_std_features, 2]

# 3. Use Descriptive Activity Names to Name the Activities in the Data Set

activities <- read.table("activity_labels.txt")

# Update Values with Correct Activity Names
ydata[, 1] <- activities[ydata[, 1], 2]

# Correct Column Name
names(ydata) <- "activity"

# 4. Appropriately Label the Data Set with Descriptive Variable Names

# Correct Column Name
names(subjectdata) <- "subject"

# bind all the data in a single data set
alldata <- cbind(xdata, ydata, subjectdata)

# 5. Create a second, independent tidy data set with the average of each variable for 
#    each activity and each subject

tidyavgdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidyavgdata, "tidyavgdata.txt", row.name=FALSE)