README.txt - Course Project: Gettting and cleaning Data
_______________________________________________________
Below is a stepwise description and associated explanation with code of what I have done for this project:


I] Loading libraries: Libraries needed for cleaning and summarizing data.
____________________
library(dplyr)
library(tidyr)

II] Loading test dataset: Simply loading from text files in my workspace 
_________________________
X_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"")
subject_test <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"")

III] Loading training dataset: Simply loading from text files in my workspace 
______________________________
X_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"")
subject_train <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"")

IV] Loading activit_labels and features: Simply loading from text files in my workspace 
________________________________________
activity_labels <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"")
head(activity_labels)
features <- read.table("C:/Projects/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"")
head(features)

V] Merging Training and Test data: Using "rbind" here to keep it simple and deal with combined data frames.
__________________________________
x<-rbind(X_train,X_test)
head(x)
y<-rbind(y_train,y_test)
head(y)
subject<-rbind(subject_train,subject_test)
head(subject)

VI] Modifying feature names to be more descriptive: Removing "()","," and "-" to make easily searchable column names using "gsub".
___________________________________________________
features_descrip<-gsub("\\(\\)","",features$V2)
features_descrip<-gsub("\\)","",features_descrip)
features_descrip<-gsub("\\(","",features_descrip)
features_descrip<-gsub("\\-","_",features_descrip)
features_descrip<-gsub("\\,","_",features_descrip)
head(features_descrip)

VII] Search for features that are only "mean"(containing mean values) and "std" (containing only standard deviations): Using "grep" for this.
______________________________________________________________________________________________________________________
observations<-grep("mean|std",features_descrip)
means_stds<-select(x,observations)
head(means_stds)

VIII] Assigning descriptive names to columns: for final tidy table.
_____________________________________________
observations<-grep("mean|std",features_descrip, value=TRUE)

for(i in 1:79) {
names(means_stds)[i]<-paste(toString(observations[i]))
}
head(means_stds)

IX] Decoding Y to reflect actual activity names: for final tidy table.
____________________________________________________
for(i in 1:10299) {
index<-as.integer(y$V1[i])
y$V1[i]<-toString(activity_labels$V2[index])
}

X] Giving column names to Y and subject: for final tidy table.
________________________________________
names(y)[1]<-paste("Activity")
head(y)
names(subject)[1]<-paste("Subject")
head(subject)

XI] Combining Subject, Y, X (only "mean" and "std" features): as asked.
_____________________________________________________________
set<-cbind(subject,y,means_stds)
head(set)

XII] Arranging data set: using arrange and group_by to get sorted data (by subject and activity)
________________________
arranged_set<-arrange(set, Subject, Activity)
summary<-arranged_set
groupedsummary<-group_by(summary,Subject,Activity)

XIII] Tidying/Summarising data: using summarise_each for getting means and summarizing subject, activity and all 79 mean/std features.
_______________________________
tidy_summary<-summarise_each(groupedsummary,funs(mean))
head(tidy_summary)

XIV]Writing tidy_summary.txt from tide_summary:
_______________________________________________
write.table(tidy_summary,file="tidy_summary.txt",row.names=FALSE)

__________________________________________________________________________________________________________________________