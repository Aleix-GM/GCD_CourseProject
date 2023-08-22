# GCD_CourseProject
Just one script in R was created to download and read the database. The script is run_analysis.R.

## Description
The first part of the script is used to download and unzip the dataset into the working directory. Once the database is accessible, we loaded the dataset into R using the function read.table for each file of the database. Check CodeBook.md for more information on the data content.
Eight variables are created to load the data, that will be merged to generate a final tidy version.
  1. a variable features that loads the file features.txt
  2. a variable activities that loadas the file activities.txt
  3. a variable x_?, y_? and subjects_? where ? means train or test
     
## Project Steps and data transformation
After loading the dataset into the R environment the steps for the project were followed.
  1. Merges the training and the test sets to create one data set\n.
     For this part the functions rbind and cbind are used to merged the variables of the environment to create a unique dataset.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
     The functions select and contains from the library dplyr are used to create a dataframe with the variables required with the measurements on the mean and standard deviation.
  3. Uses descriptive activity names to name the activities in the data set.
     The code of the activity is changed for its activity name.
  4. Appropriately labels the data set with descriptive variable names.
     The funciton gsub and regular expressions were used to change the names of the variables to the desired format.
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
     Finally group_by and summarise_all(mean) were used to create the final tidy version of the dataset. The mean for each variable is calculated grouping by activity and by subject identifier.           write.table was used to create the txt file as required.
