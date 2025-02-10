function cyclical_component = hp_filter_cyclical_inflation(ts_data)
    % Apply the HP filter to extract the cyclical component of inflation
    % 'lambda' is the smoothing parameter for the HP filter.
    % For annual data, a common value is 100; for quarterly data, 1600; for monthly data, 14400.
    % Here, we'll use 6.25 as per the provided R example.
    
    % Extract the 'Inflation_Rate_USD' column from the timetable
    inflation_rate = ts_data.Inflation_Rate_USD;
    
    % Apply the HP filter to the inflation rate data
    [~, cyclical_component] = hpfilter(inflation_rate, 6.25); % 6.25 is the lambda value used in the R code
end