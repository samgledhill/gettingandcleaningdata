
## First load required packages

library(dplyr)


## Then get datafile and unzip

if(!file.exists("data.zip")) {
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", method = "curl")
}

if(!file.exists("UCI HAR Dataset")) {
      unzip("data.zip")
}

## Step 1 - Load the dataset and merge training and test datasets into one dataframe

      features <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/features.txt", 
                             quote="\"", comment.char="", stringsAsFactors=FALSE)
      activity_labels <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/activity_labels.txt", 
                                    quote="\"", comment.char="")
      X_train <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/train/X_train.txt", 
                            quote="\"", comment.char="", stringsAsFactors=FALSE)
      y_train <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/train/y_train.txt", 
                            quote="\"", comment.char="", stringsAsFactors=FALSE)
      subject_train <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/train/subject_train.txt", 
                                  quote="\"", comment.char="")
      subject_test <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/test/subject_test.txt", 
                                 quote="\"", comment.char="", stringsAsFactors=FALSE)
      X_test <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/test/X_test.txt", 
                           quote="\"", comment.char="", stringsAsFactors=FALSE)
      y_test <- read.table("C:/Users/sam/Dropbox/Stats/bce analysis/assignment 2/UCI HAR Dataset/test/y_test.txt", 
                           quote="\"", comment.char="")

      ## First, let's appropraitely label the data. This is actually step 4 - but it seems to fit here better. The 561 column names 
      ## of the "x" table are the features list.  We need to pull the second column of that file and assign it to the names() 
      ## attribute of the x_train and x_test dataframes.

      names(X_test) <- features[,2]
      names(X_train) <- features[,2]
      
      ## Now let's rbind all three training and test sets together and while we are at it,
      ## let's also name the y_data column "activity" and the subject_data column "subject"....
      
      x_data <- rbind(X_test, X_train)
      y_data <- rbind(y_test, y_train)
      names(y_data) <- "activity"
      subject_data <- rbind(subject_test, subject_train)
      names(subject_data) <- "subject"
      
      ## And finally, cbind together the x_data (details), with y_data (the activity) and subject_data (which subject did the experiment?)
      data <- cbind(x_data, y_data, subject_data)
      
## Step 2 - Pull out only the data columns which relate to mean() and std() of the given measures
      
      ## We can subset the data table to only include columns with a label that contains "mean()" or "std()"
      ## Remember to also add back in the activity and subject columns 
      
      data_sub <- data[,c(grep("mean\\(\\)|std\\(\\)", features[,2]),562,563)]

## Step 3 - Give sensible activity labels to the activity column

      data_sub$activity <- as.factor(data_sub$activity)
      levels(data_sub$activity) <- activity_labels[,2]

## Step 5 - Remember, we covered step 4 earlier when we added labels to the dataframe in step 1!! Now we need to create a second dataframe
## which houses the average value for the existing dataset for each activity and for each subject.  
      
      average_data <- tbl_df(data_sub)
      average_data <- group_by(average_data, activity, subject)
      new_data <- summarise_each(average_data, funs(mean))
      
## Write out new_data as a CSV file for upload to GitHub
      
      write.csv(new_data, "new_data.csv")
      

