
## First load required packages

library(dplyr)


## Then get zip file of data

if(!file.exists("data.zip")) {
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", method = "curl")
}

if(!file.exists("UCI HAR Dataset")) {
      unzip("data.zip")
}


