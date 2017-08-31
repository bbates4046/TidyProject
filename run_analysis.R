
setwd("C:/Users/bbates.FIDELITONE/Documents/DataScience/UCI HAR Dataset")
activitytypeid <- read.table("activity_labels.txt",col.names = c("ID","Activity Type"))
trainactivitytype <- read.table("y_train.txt",col.names = "ID")
trainsubject <- read.table("subject_train.txt",col.names = "Subject")
traindata <- read.table("X_train.txt")
testactivitytype <- read.table("y_test.txt",col.names = "ID")
testsubject <- read.table("subject_test.txt",col.names = "Subject")
testdata <- read.table("X_test.txt")
features <- read.table("features.txt")

features1 <- gsub("-","",features$V2)
features1 <- gsub("\\()","",features1)

testdata <- `colnames<-`(testdata,features1)
traindata <- `colnames<-`(traindata,features1)


testactivitytype <- join(testactivitytype,activitytypeid, by="ID")
trainactivitytype <- join(trainactivitytype,activitytypeid, by="ID")

testdata <- cbind(testsubject,testactivitytype,testdata)
traindata <- cbind(trainsubject,trainactivitytype,traindata)


columnnamestest <- c("Subject","Activity.Type",grep("mean",colnames(testdata),value = TRUE),grep("std",colnames(testdata),value=TRUE))
columnnamestrain <- c("Subject","Activity.Type",grep("mean",colnames(traindata),value = TRUE),grep("std",colnames(traindata),value=TRUE))


testdata <- testdata[,columnnamestest]
traindata <- traindata[,columnnamestrain]


data <- rbind(testdata,traindata)

summarydata <- data %>%
		group_by(Subject,Activity.Type) %>%
		summarize_all(funs(mean))
