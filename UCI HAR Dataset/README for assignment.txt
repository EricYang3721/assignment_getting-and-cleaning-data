Week 4 Assignment
=================

1. The train and test data are loaded and merged into one data set, named "data" in the "run_analysis.R".
2. columns contains "mean()" and "std()" including the "subject_id" and "activity" in "data" are kept, and renamed as "data2".
3. Real labels are used to replace the numeric numbers in the "activity" column in the "data2"
4. Mean of each column according toeach subject and each activity are calculated and saved in dataframe "data_mean"
5. "data_final" is saved in file "merged_data.csv"
6. "data_mean" is save in file "mean_data.csv"
7. The selected features in "data_final" and "data_mean" are saved in "feature_final.csv"