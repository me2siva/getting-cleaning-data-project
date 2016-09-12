# Provide data file path and list files
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
#files
# Read Activity files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "y_train.txt"),header = FALSE)
#Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
#Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
#str(dataActivityTest)
# Merge Training and the Test sets to create one data set
## Concatenate the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
#set names to variables 
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
#Merge columns to get the data frame Data for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )


Data<-subset(Data,select=selectedNames)

#Read descriptive activity names from “activity_labels.txt”

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Creates a second,independent tidy data set and ouput it

Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.rmd",row.name=FALSE,sep='\t')


# Create code book
library("knitr")
knit2html("tidydata.rmd")
library("rmarkdown")
render("tidydata.rmd")  

