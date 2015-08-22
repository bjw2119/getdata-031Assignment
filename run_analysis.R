#This script is designed to process the Samsung data from Jeff Leek's Getting
#and Cleaning Data course for the Course Assignment. It is configured to run
#with the source files in their original unzipped folder, which has been extracted
#to the working directory. It can easily be reconfigured to read the files straight
#from the working directory if they were to be copied there.
#August 22, 2015


#Read all 3 data files (measurements, subject IDs, activites) for both test and training sets
testSet<- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
trainSet<- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
testY<- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
trainY<- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
testSubject<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
trainSubject<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

#read features.txt for column names
xlabelsfile<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

#Set column labels from features.txt
names(testSet)<- as.factor(xlabelsfile$V2)
names(trainSet)<- as.factor(xlabelsfile$V2)

#Appends activity column
testSet$activity = testY$V1
trainSet$activity = trainY$V1

#Moves activity column to front (soon-to-be 2nd) column, as activity is a dimension
testSet<- testSet[ c("activity", names(testSet)[names(testSet) != "activity"]) ]
trainSet<- trainSet[ c("activity", names(trainSet)[names(trainSet) != "activity"]) ]

#Appends subject ID column
testSet$subjID = testSubject$V1
trainSet$subjID = trainSubject$V1

#Moves subject ID to first column, as it is primary dimension
testSet<- testSet[ c("subjID", names(testSet)[names(testSet) != "subjID"]) ]
trainSet<- trainSet[ c("subjID", names(trainSet)[names(trainSet) != "subjID"]) ]

#Binds training set to testing set
fullSet<- rbind(testSet, trainSet)

#Create indices of mean and std variables
meanIndex<- grepl("mean", names(fullSet))
stdIndex<- grepl("std", names(fullSet))
activityIndex<- grepl("activity", names(fullSet))
subjIndex<- grepl("subjID", names(fullSet))

#Exctract mean and std variables from full data set into trimmed data frame
trimmedSet<- fullSet[,stdIndex | meanIndex | activityIndex | subjIndex]

#Sets activity as a factor and names its levels with descriptors from activity labels file
activitiesList<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
activitiesList<- as.factor(as.character(activitiesList$V2))
trimmedSet$activity<- factor(trimmedSet$activity)
levels(trimmedSet$activity)<- activitiesList

#Probably use ddply from plyr here or summarise/arrange from plyr. Need aggregate
aggdata<- aggregate(trimmedSet[-c(1,2)], by=list(trimmedSet$activity,trimmedSet$subjID), FUN = mean)
aggdata<- aggdata[ c("Group.2", names(aggdata)[names(aggdata) != "Group.2"]) ]

#Relabel all columns to reflect dimensions (first two) and that variables are now means
xlabelsfilemeansIndex<- grepl("mean",xlabelsfile$V2)
xlabelsfilestdIndex<- grepl("std", xlabelsfile$V2)
xmeanlabels<- xlabelsfile[xlabelsfilemeansIndex | xlabelsfilestdIndex,]
xmeanlabels$V1<- NULL
xmeanlabels$means <- paste("mean.of.", xmeanlabels$V2, sep = "")
dimslabels1<- c("subjID", "activity")
dimslabels2<- c("subjID", "activity")
dimslabels<-data.frame(dimslabels1, dimslabels2, stringsAsFactors = FALSE)
names(dimslabels)<- c("V2", "means")
xmeanlabels<- rbind(dimslabels,xmeanlabels)
meanlabelsfactor<- as.factor(xmeanlabels$means)
names(aggdata)<- meanlabelsfactor

#Creates new data frame from mean of observation for subject-activity pairs
write.table(aggdata, file = "run_analysis_tidy_output.txt", row.names = FALSE)
