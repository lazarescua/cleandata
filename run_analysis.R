library(dplyr)

##setting directories and downloading data
if(!file.exists("./course3")) {dir.create("./course3")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "./course3/temp.zip", method = "curl")

##now that we have the zip file, get the text files within
unzip("./course3/temp.zip", exdir = "./course3")

##we will not need the zip file, we can delete it
file.remove("./course3/temp.zip")

##Set the paths
rootPath <- "./course3/UCI HAR Dataset/"

##Get labels
actlabels <- read.table(paste(rootPath,"activity_labels.txt",sep = ""))

##Get column names
collabels <- read.table(paste(rootPath,"features.txt",sep = ""))

##function to get the data (doing the same things for test data and train data)
getUCIData <- function (name) {
        loadPath <- paste(rootPath, name, "/", sep = "")
        
        ##get the three files into data frames (X, y, subject)
        ##for the data we are already naming the columns with their descriptive names 
        ##(Appropriately labels the data set with descriptive variable names.)
        xdata <- read.table(paste(loadPath, "X_", name, ".txt", sep = ""), col.names = collabels[,2])
        ydata <- read.table(paste(loadPath, "y_", name, ".txt", sep = ""), col.names = c("Activity"))
        subjectdata <- read.table(paste(loadPath, "subject_", name, ".txt", sep = ""), col.names = c("Subject"))
        
        ##Uses descriptive activity names to name the activities in the data set
        ##we create a factor out of the Activity numbers and associate the labels
        ydata$Activity <- factor(ydata$Activity, levels = actlabels[,1], labels = actlabels[,2])
        
        ##add columns activity and subject to the data
        xdata$Activity <- ydata$Activity
        xdata$Subject <- subjectdata$Subject
        
        ##Extract only the measurements on the mean and standard deviation for each measurement. 
        extr <- colnames(xdata)
        extr <- extr[grep("[Mm]ean|std", extr)]
        
        xdata <- xdata[, append(c("Activity", "Subject"), extr)]
        
        xdata
}

##get the test data
testData <- getUCIData("test")
##get the training data
trainData <- getUCIData("train")

##merge all data - this is the tidy data set merged, with descriptive columns and activities
allData <- merge(testData, trainData, all = TRUE)

##From the data set in step 4 (allData), creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
avgData <- allData %>% group_by(Activity, Subject) %>% summarise_all(funs(mean))

##clean all data structures not needed anymore
rm(actlabels)
rm(collabels)
rm(testData)
rm(trainData)
rm(rootPath)
rm(fileURL)