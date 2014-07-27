##  Course Project (DataScience.005)
##  You should create one R script called run_analysis.R that does the following:

## 1. Merges the training and the test sets to create one data set.

Xtest<-read.table("X_test.txt")    ## 2947 obs  561 variables
Xtrain<-read.table("X_train.txt")  ## 7352 obs  561 variable

ytest<-read.table("y_test.txt")    ## 2947 obs  1 variables
ytrain<-read.table("y_train.txt")  ## 7352 obs  1 variables

colnames(ytest)<-"activity"        ##change variable name to "activity
colnames(ytrain)<-"activity"       ##change variable name to "activity

test<-cbind(Xtest,ytest)           #add activity column to dataframe  (2947 obs  562 variables)
train<-cbind(Xtrain,ytrain)        #add activity column to dataframe  (7352 obs  562 variables)

dataset<-merge(test,train, all=TRUE)  #merge test and train datasets (10299 obs 562 variables)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

dataset_means<-sapply(dataset[,1:561], mean, na.rm=TRUE)       ## means  on 561 variables
dataset_sd<-sapply(dataset[,1:561], sd, na.rm=TRUE)            ## sd  on 561 variables

## 3. Uses descriptive activity names to name the activities in the data set

activity_descriptions<-read.table("activity_labels.txt")     ## Get description labels from file

attach(dataset)                                              ## recode "activity" variable
dataset$activity[activity=="1"]<-"walking"
dataset$activity[activity=="2"]<-"walking_upstairs"
dataset$activity[activity=="3"]<-"walking_downstairs"
dataset$activity[activity=="4"]<-"sitting"
dataset$activity[activity=="5"]<-"standing"
dataset$activity[activity=="6"]<-"laying"
detach(dataset)

## 4. Appropriately labels the data set with descriptive variable names. 

col_labels<-read.table("features.txt")  ## read source file of descriptive labels
features<-as.character(col_labels[,2])  ## extract description column
names(dataset)<-c(features,"activity")  ## add column labels from file + activity_label 

## 5. Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject. 

subject_test<-read.table("subject_test.txt")              ## read and get subject number 2947 obs 1 variable
subject_train<-read.table("subject_train.txt")            ## read and get subject number 7352 obs 1 variable
subject<-merge(subject_test,subject_train, all=TRUE)      ## merge subject files       10299 obs  1 variable

colnames(subject)<-"subject_id"                           ## rename variable to "subject_id"
dataset2<-cbind(dataset,subject)                          ## add "subject_id" column creating 563 variables

x<-ddply(dataset2,.(c(dataset2$activity,dataset2$subject_id)), summarize, mean=colMeans(dataset2[,1:561]))

