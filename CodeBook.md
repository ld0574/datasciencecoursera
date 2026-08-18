# Code Book

## Overview

This code book describes the tidy data set produced for the Getting and Cleaning Data Course Project from the UCI Human Activity Recognition Using Smartphones data.

The original experiment involved 30 volunteers aged 19–48. Each participant wore a Samsung Galaxy S II smartphone on the waist and performed six activities. Accelerometer and gyroscope signals were recorded and processed into a set of time-domain and frequency-domain features.

## Source files used

The analysis uses these files from the `UCI HAR Dataset` directory:

- `features.txt` — names of the 561 measured features.
- `activity_labels.txt` — mapping between activity IDs and activity names.
- `train/X_train.txt` — training-set feature measurements.
- `train/y_train.txt` — training-set activity IDs.
- `train/subject_train.txt` — training-set subject IDs.
- `test/X_test.txt` — test-set feature measurements.
- `test/y_test.txt` — test-set activity IDs.
- `test/subject_test.txt` — test-set subject IDs.

The raw inertial-signal files are not used because the course assignment concerns the already calculated feature measurements.

## Transformations

### 1. Merge training and test data

The training and test feature matrices are combined row-wise. Their activity IDs and subject IDs are combined in the same order.

### 2. Select mean and standard-deviation measurements

Only original feature names matching this regular expression are retained:

```r
"-(mean|std)\\(\\)"
```

This selects 66 variables containing the calculated `mean()` or `std()` measurements. Variables such as `meanFreq()` are intentionally excluded because they represent weighted mean frequency rather than the direct mean measurement requested by the assignment.

### 3. Replace activity IDs with descriptive labels

The six numeric activity codes are replaced with the labels from `activity_labels.txt`:

- `WALKING`
- `WALKING_UPSTAIRS`
- `WALKING_DOWNSTAIRS`
- `SITTING`
- `STANDING`
- `LAYING`

### 4. Clean feature names

The original abbreviated feature names are expanded using the following rules:

- leading `t` → `Time`
- leading `f` → `Frequency`
- `Acc` → `Accelerometer`
- `Gyro` → `Gyroscope`
- `Mag` → `Magnitude`
- `mean()` → `Mean`
- `std()` → `Std`
- duplicated `BodyBody` → `Body`
- hyphens and parentheses are removed

Examples:

- `tBodyAcc-mean()-X` → `TimeBodyAccelerometerMeanX`
- `tBodyGyro-std()-Z` → `TimeBodyGyroscopeStdZ`
- `fBodyAccMag-mean()` → `FrequencyBodyAccelerometerMagnitudeMean`

### 5. Calculate averages by subject and activity

The cleaned measurements are grouped by `subject` and `activity`. For each unique subject/activity pair, the arithmetic mean of every selected measurement is calculated.

Because there are 30 subjects and 6 activities, the final tidy data set has 180 rows.

## Variables in the final tidy data

### Identifier variables

#### `subject`

Integer subject identifier ranging from 1 through 30.

#### `activity`

Descriptive categorical activity performed by the subject. Possible values are the six activity labels listed above.

### Measurement variables

The remaining 66 variables are averages of the original mean and standard-deviation measurements for each subject/activity combination.

The variable-name structure indicates:

- **Domain**: `Time` or `Frequency`
- **Signal/source**: for example `Body`, `Gravity`, `Accelerometer`, or `Gyroscope`
- **Statistic**: `Mean` or `Std`
- **Axis** when applicable: `X`, `Y`, or `Z`
- **Magnitude** when the measurement is a vector magnitude
- **Jerk** when the measurement is based on jerk signals

Representative variables include:

- `TimeBodyAccelerometerMeanX`
- `TimeBodyAccelerometerMeanY`
- `TimeBodyAccelerometerMeanZ`
- `TimeBodyAccelerometerStdX`
- `TimeBodyGyroscopeMeanX`
- `TimeBodyGyroscopeStdZ`
- `TimeGravityAccelerometerMagnitudeMean`
- `TimeBodyAccelerometerJerkMagnitudeStd`
- `FrequencyBodyAccelerometerMeanX`
- `FrequencyBodyAccelerometerStdZ`
- `FrequencyBodyGyroscopeMeanX`
- `FrequencyBodyGyroscopeMagnitudeStd`

All measurement variables are numeric. They remain in the normalized units used by the original UCI HAR feature data; the course analysis does not reverse the source normalization.

## Tidy-data structure

The final `tidy_data.txt` follows tidy-data principles:

- each variable is one column;
- each observation is one row;
- each row represents one subject/activity combination;
- each measurement cell contains one value, specifically the average of that feature for the given subject and activity.

Expected dimensions:

```text
180 rows × 68 columns
```

The 68 columns consist of 2 identifier variables and 66 averaged measurement variables.
