function ts_data = create_ts(data)
    % Copy the data to avoid modifying the original data
    data_copy = data;
    
    % Extract the start and end year of the time series (if needed)
    start_year = min(data_copy.year);
    end_year = max(data_copy.year);
    
    % Extract columns excluding TIME_PERIOD
    ts_data = data_copy(:, ~ismember(data_copy.Properties.VariableNames, 'year'));
    
    % Convert the data to a timetable, retaining time and country name
    ts_data = table2timetable(ts_data, 'RowTimes', datetime(data_copy.year, 1, 1));
end