%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%in order to use the this program, please make sure you have the following
%variable names and orders.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% year 
% Country_Name 
% ISO_code (Important for this program to run)
% Real_GDP
% Nominal_GDP
% Inflation_Rate
% Population_growth_rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Setup and Data Loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the current working directory
current_folder = pwd;

% Set the data folder path
data_folder = fullfile(current_folder, 'Data');

% Set the functions folder path and add it to the search path
functions_folder = fullfile(current_folder, 'functions');
addpath(functions_folder);

% Set the file path
IFS_data_file = fullfile(data_folder, 'IFS_data_pr.xlsx');


%read the data
IFS_raw = readtable(IFS_data_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Data Cleaning and Filtering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The Data_filtered function can filtered out the individuls countries that
%does not have at least 25 years data from the cut off point.
%Data_filtered(data, cut off year).

%noteed: the following countries will be removed due to the data gap in the
%data set

% List of countries to remove
countriesToRemove = {'Bahrain, Kingdom of', 'Benin', 'Egypt, Arab Rep. of'};

% Find rows where Country_Name matches any entry in countriesToRemove
rowsToRemove = ismember(IFS_raw.Country_Name, countriesToRemove);

% Remove those rows from the dataset
IFS_raw(rowsToRemove, :) = [];


IFS_filtered = Data_filtered(IFS_raw, 2019, 50);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3. Apply the log transformation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%doing a log transformation for the entire data_set. 
%if will do the log transformation for both real and nominal gdp.

IFS_log = log_transform_time_series(IFS_filtered)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Create Timetable for Each Country
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function will build the time table.
%build_time_table = (data, cut-off year)

IFS_ts_log = Build_time_table(IFS_log, 2019);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. HP Filter to Detrend GDP Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%6.25 is for the smoothing factor of the HP filter.
IFS_ts_log_HP_QD = HP_QD_data(IFS_ts_log, 6.25)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. Calculate Nominal GDP Growth Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IFS_ts_log_HP_QD_GR = calculate_GDP_growth_rate(IFS_ts_log_HP_QD)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%last check 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%make sure all the data point have atleast 25 years of data
IFS_ts_log_HP_QD_GR_LC = last_check(IFS_ts_log_HP_QD_GR, 'annual' , 25)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the processed datasets to the 'Data' folder as MAT files only
save(fullfile('Data', 'IFS_processed_data.mat'), 'IFS_ts_log_HP_QD_GR_LC');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calcuate the average time!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IFS_ts_log_HP_QD_GR_avg = average_inflation_population_growth(IFS_ts_log_HP_QD_GR, 'IFS_avrage.mat', 'IFS_average.csv', 50, []);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_dir = 'Data'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now, its the time to calculate the two stage regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%note: stage_one_regression(data , what type of smoothing you want (HP/QD), 'IFS' here is the for the average inflation);
IFS_stage_one_regresison_HP = stage_one_regression(IFS_ts_log_HP_QD_GR_LC, 'HP', 'IFS');
IFS_stage_one_regresison_QD = stage_one_regression(IFS_ts_log_HP_QD_GR_LC, 'QD', 'IFS');


%remove the same things
[~, idx] = unique(IFS_stage_one_regresison_HP(:, {'Country', 'ISO_code'}), 'rows');
IFS_stage_one_regresison_HP_unique = IFS_stage_one_regresison_HP(idx, :);
[~, idx] = unique(IFS_stage_one_regresison_QD (:, {'Country', 'ISO_code'}), 'rows');
IFS_stage_one_regresison_QD_unique = IFS_stage_one_regresison_QD (idx, :);

% Save IFS results
writetable(IFS_stage_one_regresison_HP_unique, fullfile('Data', 'IFS_stage_one_regresison_HP.xlsx'));
writetable(IFS_stage_one_regresison_QD_unique , fullfile('Data', 'IFS_stage_one_regresison_QD.xlsx'));

%The EIU statstic
%EIU_statistics(date, [], 'Persistence or Impact');
%the data 
%OECD = 1, OECD = 0 or [] for all the data
%select between Persistence or Impact
%HP
EIU_statistics(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%HP
EIU_statistics(IFS_stage_one_regresison_HP_unique, [], 'Impact');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Impact');

%QD
EIU_statistics(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%QD
EIU_statistics(IFS_stage_one_regresison_HP_unique, [], 'Impact');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
EIU_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Impact');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The EIU_statistics_binary
%EIU_statistics(date, [], 'Persistence or Impact');
%the data 
%OECD = 1, OECD = 0 or [] for all the data
%select between Persistence or Impact
%set the EUI greater than 6 as democracy = 1 and blow the 6 as
%non-democracy = 0

%HP
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%HP
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, [], 'Impact');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 0, 'Impact');

%QD
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%QD
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, [], 'Impact');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
EIU_statistics_binary(IFS_stage_one_regresison_HP_unique, 0, 'Impact');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The AveragePopulationGrowth_statistics
%AveragePopulationGrowth_statistics(date, [], 'Persistence or Impact');
%the data 
%OECD = 1, OECD = 0 or [] for all the data
%select between Persistence or Impact
%set the EUI greater than 6 as democracy = 1 and blow the 6 as
%non-democracy = 0

%HP
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%HP
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, [], 'Impact');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Impact');

%QD
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, [], 'Persistence');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Persistence');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Persistence');

%QD
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, [], 'Impact');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 1, 'Impact');
AveragePopulationGrowth_statistics(IFS_stage_one_regresison_HP_unique, 0, 'Impact');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%

