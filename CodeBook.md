---
title: "CodeBook.md"
author: "bjw2119"
date: "August 22, 2015"
output: html_document
---
This Code Book describes the processes used by the R script "run_analysis.R" to clean and aggregate the means and standard deviations of acceleration, magnitude, and Fast-Fourier transformed data collected from Samsung smartphones' acclerometers and gyroscopes worn by 30 subjects performing Activities of Daily Living in the study: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. Documentation for the study's variables found in the "features_info.txt" file was used in the constructino of this Code Book.
##Untidy Data Format and Layout

The *Anguita et al* data file is split into two categories, one for training and the other for testing, with observations of 21 and 9 subjects each, respectively. Both the testing and training group each have three data files in the .txt format: a table of observations of 561 vector measures relating to acceleration along the x,y, and z axes; an index listing the subject ID number associated with the aforementioned observations; and an index listing th ADL activity taking place during the observation, as coded by hand by observers reviewing videotapes of the study.

##Script

###Test and Training Set Assembly

The run_analysis.R script begins by loading 3 data files in a .txt format each from both the test group folder and the training group folder using

*read.table(file_path)*

An additional file, "features.txt" containing the labels of the acceleration variable measurements is also read in as a table.

The variables are appended to their respective columns using the names() function to assign the labels to the observation table columns after converting the labels to factor variables using as.factor().

The activity and subject ID dimensions are then simply appended to the data frames as new columns using the df$column = vector assignment method, after which they are moved to the front (left) of the dataset to make it easier for readers to orient themselves by the subject ID and activity dimensions.

The now-complete test and training set data frames are bound together using rbind to create the fullSet data frame.

###Filtering and Aggregation

Two logical vectors are created using the grepl() function to identify column variables with "mean" and "std" measurements (including mean frequency variables from Fast Fourier Transformations) created by *Anguino et al*. These vectors are then used with [] to extract the columns from fullSet to be placed into the trimmedSet variable, after which the activity and subject ID dimension columns are appended, moved to the front, and the column labels re-attached.

The aggregation() function is then run by subject ID and activity to create means of the selected mean and std columns in the trimmedSet. The resulting aggregated set is stored in the variable aggdata.

The column labels are updated to reflect that they are the means of the original study's vector fields using the paste() function. (See "Variables" below).

###Output
The resulting tidy data set is written to a .txt file with no row names, run_analysis_tidy_output.txt, using write.table(). The output can also easily be written to a .csv file for ease of viewing.


##Variables
The variables included in this output are the means of 79 means and standard deviations of measures included in the original *Anguina et al* data set, as well as the two dimenional variables, subject ID and activity. There are 26 original types of measurements taken, including 19 measurements and statistics on accerlation along the X, Y, and Z axes (for a total of 57). Also included are the mean and standard deviation of the following: body, gyroscope, and gravity acceleration magnitude; and body and gyroscopte acceleration jerk magnitude (for a total of 10). Finally, mean, standard deviation, and mean frequency of the Fast Fourier transformation of body acceleration magnitude, body acceleration jerk magnitude, body gyroscopic acceleration magnitude, and body gyroscopic accleration jerk magnitude are also included (for a total of 12). These 79 (57+10+12), in addition to the activity and subject ID dimensions (2) result in the following 81 variables (the 79 non-dimensional variables are the means of the data from *Anguina et al*:

-subjID
-activity
-mean.of.tBodyAcc-mean()-X
-mean.of.tBodyAcc-mean()-Y
-mean.of.tBodyAcc-mean()-Z
-mean.of.tBodyAcc-std()-X
-mean.of.tBodyAcc-std()-Y
-mean.of.tBodyAcc-std()-Z
-mean.of.tGravityAcc-mean()-X
-mean.of.tGravityAcc-mean()-Y
-mean.of.tGravityAcc-mean()-Z
-mean.of.tGravityAcc-std()-X
-mean.of.tGravityAcc-std()-Y
-mean.of.tGravityAcc-std()-Z
-mean.of.tBodyAccJerk-mean()-X
-mean.of.tBodyAccJerk-mean()-Y
-mean.of.tBodyAccJerk-mean()-Z
-mean.of.tBodyAccJerk-std()-X
-mean.of.tBodyAccJerk-std()-Y
-mean.of.tBodyAccJerk-std()-Z
-mean.of.tBodyGyro-mean()-X
-mean.of.tBodyGyro-mean()-Y
-mean.of.tBodyGyro-mean()-Z
-mean.of.tBodyGyro-std()-X
-mean.of.tBodyGyro-std()-Y
-mean.of.tBodyGyro-std()-Z
-mean.of.tBodyGyroJerk-mean()-X
-mean.of.tBodyGyroJerk-mean()-Y
-mean.of.tBodyGyroJerk-mean()-Z
-mean.of.tBodyGyroJerk-std()-X
-mean.of.tBodyGyroJerk-std()-Y
-mean.of.tBodyGyroJerk-std()-Z
-mean.of.tBodyAccMag-mean()
-mean.of.tBodyAccMag-std()
-mean.of.tGravityAccMag-mean()
-mean.of.tGravityAccMag-std()
-mean.of.tBodyAccJerkMag-mean()
-mean.of.tBodyAccJerkMag-std()
-mean.of.tBodyGyroMag-mean()
-mean.of.tBodyGyroMag-std()
-mean.of.tBodyGyroJerkMag-mean()
-mean.of.tBodyGyroJerkMag-std()
-mean.of.fBodyAcc-mean()-X
-mean.of.fBodyAcc-mean()-Y
-mean.of.fBodyAcc-mean()-Z
-mean.of.fBodyAcc-std()-X
-mean.of.fBodyAcc-std()-Y
-mean.of.fBodyAcc-std()-Z
-mean.of.fBodyAcc-meanFreq()-X
-mean.of.fBodyAcc-meanFreq()-Y
-mean.of.fBodyAcc-meanFreq()-Z
-mean.of.fBodyAccJerk-mean()-X
-mean.of.fBodyAccJerk-mean()-Y
-mean.of.fBodyAccJerk-mean()-Z
-mean.of.fBodyAccJerk-std()-X
-mean.of.fBodyAccJerk-std()-Y
-mean.of.fBodyAccJerk-std()-Z
-mean.of.fBodyAccJerk-meanFreq()-X
-mean.of.fBodyAccJerk-meanFreq()-Y
-mean.of.fBodyAccJerk-meanFreq()-Z
-mean.of.fBodyGyro-mean()-X
-mean.of.fBodyGyro-mean()-Y
-mean.of.fBodyGyro-mean()-Z
-mean.of.fBodyGyro-std()-X
-mean.of.fBodyGyro-std()-Y
-mean.of.fBodyGyro-std()-Z
-mean.of.fBodyGyro-meanFreq()-X
-mean.of.fBodyGyro-meanFreq()-Y
-mean.of.fBodyGyro-meanFreq()-Z
-mean.of.fBodyAccMag-mean()
-mean.of.fBodyAccMag-std()
-mean.of.fBodyAccMag-meanFreq()
-mean.of.fBodyBodyAccJerkMag-mean()
-mean.of.fBodyBodyAccJerkMag-std()
-mean.of.fBodyBodyAccJerkMag-meanFreq()
-mean.of.fBodyBodyGyroMag-mean()
-mean.of.fBodyBodyGyroMag-std()
-mean.of.fBodyBodyGyroMag-meanFreq()
-mean.of.fBodyBodyGyroJerkMag-mean()
-mean.of.fBodyBodyGyroJerkMag-std()
-mean.of.fBodyBodyGyroJerkMag-meanFreq()
