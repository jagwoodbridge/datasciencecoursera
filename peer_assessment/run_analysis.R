## Activate required packages
require(reshape)

## Import relevant data
print("Reading in Test and Train data sets")
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/Y_test.txt")
subject_test<-read.table("test/subject_test.txt")
x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/Y_train.txt")
subject_train<-read.table("train/subject_train.txt")
activity_labels<-read.table("activity_labels.txt")
head_names<-read.table("features.txt")

## Bind test and training data with the assumption that origin of
## data not required in later analysis

print("Combining Test and Train data sets.")
X<-rbind(x_train,x_test)
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)

## Convert activity numeric code to activity labels
print("Adding activity descriptions.")
y<-merge(y,activity_labels,by.x="V1",by.y="V1")
y<-as.data.frame(y[,2])

## Add Names of Columns
print("Converting column names.")
colnames(X)<-head_names[,2]
colnames(y)<-"Activity"
colnames(subject)<-"Subject"

## Extract means and standard deviation columns and create final data set
print("Combining data set.")
data_means<-X[,grep("mean",names(X))]
data_std<-X[,grep("std",names(X))]
data_means<-data_means[,-grep("meanF",names(data_means))]
data_all<-cbind(data_means,data_std,y,subject)

## Calculate data set containing averages of combined data set for each activity and each subject
print("Calculating averages by Activity and Subject.")
temp<-melt(data_all,id=c("Activity","Subject"))
temp2<-dcast(temp,Activity+Subject~variable,mean)

## Export combined data set
print("Exporting final data set.")
write.table(temp2,"ave_data.txt",sep=",",col.names=FALSE,row.names=FALSE)

print("Process complete.")