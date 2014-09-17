
#load dependency. data.table is required to apply the mean by two groups
library(data.table)



###  Go to the project directory

setwd("~/archivo/Coursera - Getting and Cleaning Data/Course Project")


### Load each data set and labels as a frame

testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
testlabel <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
testsubj <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
trainlabel <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
trainsubj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

##### Name columns before merging into a big data frame

### Change the activities in the data sets for those in the file activity_labels
act <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")

testlabel$V1 <- factor(testlabel$V1, levels=act$V1, labels=act$V2)
trainlabel$V1 <- factor(trainlabel$V1, levels=act$V1, labels=act$V2)

### Load the measurements names as a data frame
carac <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")

### apply the features names vector to name the columns in the training and test data sets
names(testdata) <- carac$V2
names(traindata) <- carac$V2
names(testlabel) <- c("activity")
names(trainlabel) <- c("activity")
names(testsubj) <- c("subject")
names(trainsubj) <- c("subject")

### Merges the training and the test sets to create one data set.
test<-cbind(testlabel, testdata)
test<-cbind(testsubj,test)

train<-cbind(trainlabel,traindata)
train<-cbind(trainsubj,train)

all<-rbind(train,test)

### Extracts only the measurements on the mean and standard deviation for each measurement
mediana<-sapply(all, mean, na.rm=TRUE)
std<-sapply(all, sd, na.rm=TRUE)

### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Need to use the data.table package. From the vignette:
#When grouping, the j expression can use column names as variables, as you know, but it can also use a reserved symbol .SD which refers to the Subset of the Data.table for each group (excluding the grouping columns). So to sum up all your columns it’s just DT[,lapply(.SD,sum),by=grp].
#This way I can apply the mean function to every column, grouped by subject and activity. From the documentation ?data.table by can be "a list() of expressions of column names


#convert my data frame to a data table
DT <- data.table(all)

# apply the mean function to groups of activities and subjects. Generate the tidy data set
all_tidy<-DT[,lapply(.SD,mean), by="subject,activity"]

# write out the tidy data set
write.table(all_tidy, file="all_tidy.txt", sep="\t", row.names = FALSE)








