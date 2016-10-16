library(dplyr)
# 1. Merges the training and the test sets to create one data set.
# Get training data from x_train, y_train, and features to form a train_data dataframe. 
subject_train <- read.table("./train/subject_train.txt")   # subjects: 7352 observations
train_data_x <- read.table("./train/X_train.txt")       # read train features 7352X561
train_data_y <- read.table("./train/y_train.txt") # read tain 7532X1 label
train_data <- bind_cols(subject_train, train_data_x) # Bind subject_train in first column
train_data <- bind_cols(train_data, train_data_y) # Bind label in last column
features <- read.table("features.txt")[,2] # 561X1
features <- c("subject_id", as.vector(features), "activity")   # add "subject_id" from subject_train, "activity" from label
features_unique <- make.unique(features) # Make the duplicated column names unique e.g.change c("abc", "def", abc") to c("abc", "def", abc.1")
colnames(train_data) <- features_unique   # Add names to each column of the train_data

# Get test data from x_test, y_test, and features to form a test_data dataframe
subject_test <- read.table("./test/subject_test.txt")  # subjects: 2947 observations
test_data_x <- read.table("./test/X_test.txt")       # read test features 2947X561
test_data_y <- read.table("./test/y_test.txt") # read test labels 2947X1
test_data <- bind_cols(subject_test, test_data_x) # Bind subject_train in first column
test_data <- bind_cols(test_data, test_data_y) # Bind label in last column
colnames(test_data) <- features_unique   # Add names to each column of the test_data

data <- bind_rows(train_data, test_data) # merge train and test data set as one data set

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
substracted_features <- grep(pattern = '(mean\\(\\)|std\\(\\))', x=features, value=TRUE) # Form a substracted features with only mean  and std
substracted_features <- c("subject_id", substracted_features, "activity") # Add "subject_id and activity in the substrated features.
data2<-data[,substracted_features]# Select the columns with mean and std, and keep the columns of subject_id and activity


# 3.Uses descriptive activity names to name the activities in the data set
label <- read.table("activity_labels.txt")[,2] # read the labels 
findLabel <- function(x){label[as.numeric(x)]} # define a function to replace numeric numbers to according activities
data2$activity<-sapply(data2$activity, findLabel) # replace the numbers in data2$activity into according activities

#4. Appropriately labels the data set with descriptive variable names.
# this has been done in step 1 and 2, where the features or substracted_features are assigned to the according columns
data_final <- data2 # data_final is the final data set

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.
data_mean <- data.frame(NULL)

#calculate mean according to each subject and activity
for (i in 1:30) {
  for (j in label) {
    selected <- filter(data_final, subject_id==i, activity == j) #select the dataframe with subject: i and actitivty:j
    selected <- select(selected, -subject_id, -activity) # only keep the numeric values (the ones to be averaged)
    average <- sapply(selected,mean) # get the mean of each column
    averaged_row <- c(i, as.character(average), j) # add subject_id and activity to the averaged vector
    temp <- as.data.frame(t(averaged_row)) # Convert the vector into a one row dataframe
    data_mean <- bind_rows(data_mean, temp) # add the row to the dataframe_mean
  }
}
mean_names <- names(data_final) # Get the names of the data_final, before averaging
mean_names <- paste0(mean_names,"_mean") # Add "_mean" to the end of each variable name
colnames(data_mean) <- mean_names # Add the column names of the data_mean as the new name "mean_names".

# write data_mean in "mean_data.csv"
write.csv(data_mean, file="mean_data.csv")
# write data_final in "merged_data.csv"
write.csv(data_final, "merged_data.csv")
# write selected features in "feature_final.csv"
write.csv(names(data_final), "feature_final.csv")

