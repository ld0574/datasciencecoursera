# Getting and Cleaning Data Course Project

This repository contains the solution for the **Getting and Cleaning Data Course Project** using the UCI Human Activity Recognition Using Smartphones data set.

## Files

- `run_analysis.R` — downloads the source data if necessary and performs all cleaning and transformation steps required by the assignment.
- `tidy_data.txt` — the final independent tidy data set produced by `run_analysis.R`. It contains the average of each selected mean/std measurement for each subject and activity.
- `merged_mean_std_data.txt` — optional intermediate data set after merging, selecting mean/std measurements, applying activity labels, and cleaning variable names.
- `CodeBook.md` — describes the source data, variables, transformations, and the structure of the final tidy data set.

## Source data

The project uses the **Human Activity Recognition Using Smartphones Dataset**. The measurements were collected from the accelerometer and gyroscope of a Samsung Galaxy S II worn by 30 volunteers while they performed six activities.

Course data URL:

`https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

## How to run

Place `run_analysis.R` in an empty working directory and run:

```r
source("run_analysis.R")
```

The script downloads and unzips the source data automatically when the `UCI HAR Dataset` directory is not already present.

It then creates:

```text
merged_mean_std_data.txt
tidy_data.txt
```

No additional R packages are required.

## Processing steps

The script implements the five assignment requirements in order:

1. Reads and merges the training and test observations.
2. Retains only feature columns whose original names contain `-mean()` or `-std()`.
3. Replaces numeric activity IDs with descriptive activity names.
4. Expands and cleans the feature names to make them descriptive and readable.
5. Groups the cleaned data by `subject` and `activity`, then calculates the mean of every selected measurement.

## Final tidy data

There are 30 subjects and 6 activities, so the final data set contains:

- **180 observations**: 30 subjects × 6 activities
- **68 variables**: `subject`, `activity`, and 66 averaged measurements

Each row represents one unique subject/activity combination. Each measurement column contains the average value for that combination.

The final file is written using:

```r
write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
```

It can be read back into R with:

```r
x <- read.table("tidy_data.txt", header = TRUE)
View(x)
```
