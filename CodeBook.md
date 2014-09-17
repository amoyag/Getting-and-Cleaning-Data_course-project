This document describes the data, the variables and the work performed to tidy up the data sets.
# Data description
From the website where the data were downloaded (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones):
- Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
- The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
- The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
# Variables description
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 
- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean
# Transformations performed on the raw data
## Download the raw data
Raw data were downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Unziped and stored in UCI HAR Dataset.

## Load each data set and labels as a frame

``
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)

testlabel <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)

testsubj <- read.table("./UCI HAR Dataset/test/	subject_test.txt", header=FALSE)

traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)

trainlabel <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE
)
trainsubj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

``
## Name columns before merging into a big data frame
It is easier to use descriptive activity names to name the activities in each data set before merging them in the complete data set.

``
act <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")
carac <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
testlabel$V1 <- factor(testlabel$V1, levels=act$V1, labels=act$V2)
trainlabel$V1 <- factor(trainlabel$V1, levels=act$V1, labels=act$V2)
names(testdata) <- carac$V2
names(traindata) <- carac$V2
names(testlabel) <- c("activity")
names(trainlabel) <- c("activity")
names(testsubj) <- c("subject")
names(trainsubj) <- c("subject")
``
## Merge the training and the test sets to create one data set.
``
test<-cbind(testlabel, testdata)
test<-cbind(testsubj,test)
train<-cbind(trainlabel,traindata)
train<-cbind(trainsubj,train)
all<-rbind(train,test)
``
## Transform the data frame into a data table
The package <code>data.table</code> allows to apply the mean function to every column, grouped by subject and activity.

``
library(data.table)
DT <- data.table(all)
all_tidy<-DT[,lapply(.SD,mean), by="subject,activity"]
``

## Write out the tidy data set
``
write.table(all_tidy, file="all_tidy.txt", sep="\t", row.names = FALSE)
``