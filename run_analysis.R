# run_analysis.R
# Getting and Cleaning Data Course Project
#
# This script:
# 1. Merges the training and test sets.
# 2. Extracts measurements on mean and standard deviation.
# 3. Uses descriptive activity names.
# 4. Applies descriptive variable names.
# 5. Creates an independent tidy data set containing the average of each
#    selected variable for each subject and activity.

# -----------------------------------------------------------------------------
# 0. Download and unzip the source data when needed
# -----------------------------------------------------------------------------

data_url <- paste0(
  "https://d396qusza40orc.cloudfront.net/",
  "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
)
zip_file <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!dir.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    download.file(data_url, zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# -----------------------------------------------------------------------------
# 1. Read metadata
# -----------------------------------------------------------------------------

features <- read.table(
  file.path(data_dir, "features.txt"),
  col.names = c("feature_id", "feature_name"),
  stringsAsFactors = FALSE
)

activity_labels <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  col.names = c("activity_id", "activity"),
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# 2. Read training and test data and merge them
# -----------------------------------------------------------------------------

x_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"))
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"))

x_test <- read.table(file.path(data_dir, "test", "X_test.txt"))
y_test <- read.table(file.path(data_dir, "test", "y_test.txt"))
subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"))

x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)

# -----------------------------------------------------------------------------
# 3. Extract only mean() and std() measurements
# -----------------------------------------------------------------------------
# This deliberately excludes meanFreq(), because the assignment asks for the
# mean and standard deviation measurements themselves.

selected <- grep("-(mean|std)\\(\\)", features$feature_name)
selected_feature_names <- features$feature_name[selected]
x_selected <- x_all[, selected, drop = FALSE]

# -----------------------------------------------------------------------------
# 4. Use descriptive activity names
# -----------------------------------------------------------------------------

activity <- activity_labels$activity[match(y_all[[1]], activity_labels$activity_id)]
activity <- factor(activity, levels = activity_labels$activity)

# -----------------------------------------------------------------------------
# 5. Apply descriptive variable names
# -----------------------------------------------------------------------------

clean_feature_names <- selected_feature_names
clean_feature_names <- gsub("^t", "Time", clean_feature_names)
clean_feature_names <- gsub("^f", "Frequency", clean_feature_names)
clean_feature_names <- gsub("BodyBody", "Body", clean_feature_names, fixed = TRUE)
clean_feature_names <- gsub("Acc", "Accelerometer", clean_feature_names, fixed = TRUE)
clean_feature_names <- gsub("Gyro", "Gyroscope", clean_feature_names, fixed = TRUE)
clean_feature_names <- gsub("Mag", "Magnitude", clean_feature_names, fixed = TRUE)
clean_feature_names <- gsub("-mean\\(\\)", "Mean", clean_feature_names)
clean_feature_names <- gsub("-std\\(\\)", "Std", clean_feature_names)
clean_feature_names <- gsub("-", "", clean_feature_names, fixed = TRUE)
clean_feature_names <- gsub("\\(", "", clean_feature_names)
clean_feature_names <- gsub("\\)", "", clean_feature_names)

names(x_selected) <- clean_feature_names

merged_data <- data.frame(
  subject = subject_all[[1]],
  activity = activity,
  x_selected,
  check.names = FALSE
)

# Optional intermediate output corresponding to the cleaned data after step 4.
write.table(
  merged_data,
  file = "merged_mean_std_data.txt",
  row.names = FALSE,
  quote = FALSE
)

# -----------------------------------------------------------------------------
# 6. Create the independent tidy data set
#    Average of each variable for each activity and each subject
# -----------------------------------------------------------------------------

tidy_data <- aggregate(
  merged_data[, -(1:2), drop = FALSE],
  by = list(subject = merged_data$subject, activity = merged_data$activity),
  FUN = mean
)

tidy_data <- tidy_data[order(tidy_data$subject, tidy_data$activity), ]
row.names(tidy_data) <- NULL

write.table(
  tidy_data,
  file = "tidy_data.txt",
  row.names = FALSE,
  quote = FALSE
)

# Basic validation useful for the course project.
stopifnot(nrow(tidy_data) == 180)
stopifnot(ncol(tidy_data) == 68)

message("Analysis complete.")
message("Created merged_mean_std_data.txt")
message("Created tidy_data.txt (180 rows x 68 columns)")
