# Code Book

This document will describe the code in the `run_analysis.R` file in this repo.
The R file also contains comments to understand all the steps.

The code has these parts:
- Dependencies
- Getting data files and unzipping
- Function to get the data and tidy it
- Merge data from test and training
- Create the summary data frame

## Dependencies
The code depends on the `dplyr` package. This is used to create the summary dataframe.

##Getting data files and unzipping
The code will create a subfolder called `course3` in the working directory. (if it does not exist)
Then it will download the file located here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Finally it will unzip the archive in the course3 subdirectory.

## Function
Since we have two datasets that have the same variables, we built a function that takes as input the name of the data set to be processed (either `test` or `train`)
The function will read the X_… table (actual measurements), the y_… table (activities) and the subject_… (subjects data), then add the activities (as labels, according to the labels in `activity_labels.txt`) and the subjects.
Finally, we are extracting only the variables that represent Mean and Average measurements.

## Merge data
We use the merge function to merge the two data frames together as one
The resulting data frame (allData) is the tidy data set we are looking for

## Summary data frame
We use the dplyr functions group_by and summarise_all to get the means for each Activity and Subject. The result is stored in the dataframe `avgData`.

## Clean up
We remove all variables except the two data frames: `allData` and `avgData`.

# Result

The resulting data looks like this:

## allData

        > head(allData[, 1:5], n=3)
          Activity Subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
        1  WALKING       1         0.1561866       -0.04961459       -0.11290104
        2  WALKING       1         0.1801943       -0.01779685       -0.03934704
        3  WALKING       1         0.1902231       -0.03889705       -0.09869604

## avgData

        > head(avgData[, 1:5], n=3)
        # A tibble: 3 x 5
        # Groups:   Activity [1]
          Activity Subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
          <fct>      <int>             <dbl>             <dbl>             <dbl>
        1 WALKING        1             0.277           -0.0174            -0.111
        2 WALKING        2             0.276           -0.0186            -0.106
        3 WALKING        3             0.276           -0.0172            -0.113
