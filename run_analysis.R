

library(dplyr)
library(tidyr)

X_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"")
subject_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"")

X_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"")
subject_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"")

activity_labels <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"")
head(activity_labels)

features <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"")
head(features)

x<-rbind(X_train,X_test)
head(x)
y<-rbind(y_train,y_test)
head(y)
subject<-rbind(subject_train,subject_test)
head(subject)

features_descrip<-gsub("\\(\\)","",features$V2)
features_descrip<-gsub("\\)","",features_descrip)
features_descrip<-gsub("\\(","",features_descrip)
features_descrip<-gsub("\\-","_",features_descrip)
features_descrip<-gsub("\\,","_",features_descrip)
head(features_descrip)

observations<-grep("mean|std",features_descrip)
means_stds<-select(x,observations)
head(means_stds)

observations<-grep("mean|std",features_descrip, value=TRUE)

for(i in 1:79) {
names(means_stds)[i]<-paste(toString(observations[i]))
}
head(means_stds)

for(i in 1:10299) {
index<-as.integer(y$V1[i])
y$V1[i]<-toString(activity_labels$V2[index])
}

names(y)[1]<-paste("Activity")
head(y)
names(subject)[1]<-paste("Subject")
head(subject)

set<-cbind(subject,y,means_stds)
head(set)

arranged_set<-arrange(set, Subject, Activity)
summary<-arranged_set
groupedsummary<-group_by(summary,Subject,Activity)
tidy_summary<-summarise_each(groupedsummary,funs(mean))
head(tidy_summary)

write.table(tidy_summary,file="tidy_summary.txt",row.names=FALSE)


