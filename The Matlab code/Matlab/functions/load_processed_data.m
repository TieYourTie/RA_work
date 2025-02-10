function [WB_log, average_inflation_table] = load_processed_data()
    % Load processed data from a MAT file
    % The MAT file contains the variables WB_log and average_inflation_table
    load('processed_data.mat', 'WB_log', 'average_inflation_table');
end
