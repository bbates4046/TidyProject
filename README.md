# TidyProject

This file does the following transformations to a data-set described in the code book. It takes two data-sets, creates tidy variable names, filters to only have mean and std observations, merges the two data-sets and then creates a tidy dataset the has the overall mean for every variable and subject in the data-set.

##Load data source from source folder (Save the data found in the link in the Project Data section to your working directory)

setwd("C:/Users/bbates.FIDELITONE/Documents/DataScience/UCI HAR Dataset")

activitytypeid <- read.table("activity_labels.txt",col.names = c("ID","Activity Type"))

trainactivitytype <- read.table("y_train.txt",col.names = "ID")

trainsubject <- read.table("subject_train.txt",col.names = "Subject")

traindata <- read.table("X_train.txt")

testactivitytype <- read.table("y_test.txt",col.names = "ID")

testsubject <- read.table("subject_test.txt",col.names = "Subject")

testdata <- read.table("X_test.txt")

features <- read.table("features.txt")

##change the features column names to be more user-readable

features1 <- gsub("-","",features$V2)

features1 <- gsub("\\()","",features1)

##set column names in the training and test data-set to the features variable names

testdata <- `colnames<-`(testdata,features1)

traindata <- `colnames<-`(traindata,features1)

##change the activity type id in the test (testactivitytype) and train data-set to it's corresponding activity name

testactivitytype <- join(testactivitytype,activitytypeid, by="ID")

trainactivitytype <- join(trainactivitytype,activitytypeid, by="ID")

##add the activity type and the subject column to the test and train data set

testdata <- cbind(testsubject,testactivitytype,testdata)

traindata <- cbind(trainsubject,trainactivitytype,traindata)



##Create a vector of column names we want included in the dataset

columnnamestest <- c("Subject","Activity.Type",grep("mean",colnames(testdata),value = TRUE),grep("std",colnames(testdata),value=TRUE))

columnnamestrain <- c("Subject","Activity.Type",grep("mean",colnames(traindata),value = TRUE),grep("std",colnames(traindata),value=TRUE))

##Subset the test and train data to only include the column names in the column names vector

testdata <- testdata[,columnnamestest]

traindata <- traindata[,columnnamestrain]

##Merge the two data sets (test and train)

data <- rbind(testdata,traindata)

##Create a tidy data-set with averages for each variable within a subject and activity type

summarydata <- data %>%
		group_by(Subject,Activity.Type) %>%
		summarize_all(funs(mean))

##Create a text file with the summarydata

write.table(summarydata,file = "Project",row.names=FALSE)
