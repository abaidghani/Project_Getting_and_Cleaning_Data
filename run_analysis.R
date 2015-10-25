# R script file run_analysis.R, that does the followin:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#---------------------------------

# There are some dependecies that will be loaded automatically if required.

if (!require("data.table")) { install.packages("data.table") } 
if (!require("reshape2")) { install.packages("reshape2") } 

library("data.table")
library(reshape2)

# 1. Merges the training and the test sets to create one data set.

# x_train and y_train 
subject_train <- read.table("train/subject_train.txt") 
X_train <- read.table("train/X_train.txt") 
y_train <- read.table("train/y_train.txt") 
# column name
names(subject_train) <- "subjectID"


# x_test and y_test
subject_test <- read.table("test/subject_test.txt") 
X_test <- read.table("test/X_test.txt") 
y_test <- read.table("test/y_test.txt") 
# column name
names(subject_test) <- "subjectID" 


# column names - measurement and label files 
featureNames <- read.table("features.txt") 
names(X_train) <- featureNames 
names(X_test) <- featureNames 
# label
names(y_train) <- "activity" 
names(y_test) <- "activity" 


# Bind, merge test and train data
train <- cbind(subject_train, y_train, X_train) 
test <- cbind(subject_test, y_test, X_test) 
combined <- rbind(train, test) 

# preparing tidy file
id_labels   = c("subjectID","activity")
melted_Data <- melt(combined, id = id_labels)
tidy_file <- dcast(melted_Data, subjectID+activity ~ variable, mean)
# Creating CSV
write.csv(tidy_file, "tidy_Data.txt", row.names=FALSE)
