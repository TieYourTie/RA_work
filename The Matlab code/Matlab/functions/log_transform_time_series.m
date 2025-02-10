function data_log = log_transform_time_series_table(data)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % log_transform_time_series_table
    % This function takes a table containing time series data for each country,
    % performs a log transformation on specified fields, and returns the
    % transformed data as a new table with additional log-transformed columns.
    %
    % Input:
    %   data - a table with columns 'Country_Name', 'Year', 'Real_GDP',
    %          and 'Nominal_GDP'
    %
    % Output:
    %   data_log - a table with the original data and additional log-transformed columns
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialize the new table as a copy of the original data
    data_log = data;

    % Check if columns are present in the table
    if ismember('Real_GDP', data.Properties.VariableNames)
        % Apply log transformation only to positive values
        valid_real_gdp = data.Real_GDP > 0;
        data_log.log_Real_GDP = NaN(height(data), 1); % Initialize with NaN
        data_log.log_Real_GDP(valid_real_gdp) = log(data.Real_GDP(valid_real_gdp));
    else
        warning('Column Real_GDP is missing from the table.');
    end

    if ismember('Nominal_GDP', data.Properties.VariableNames)
        % Apply log transformation only to positive values
        valid_nominal_gdp = data.Nominal_GDP> 0;
        data_log.log_Nominal_GDP = NaN(height(data), 1); % Initialize with NaN
        data_log.log_Nominal_GDP(valid_nominal_gdp) = log(data.Nominal_GDP(valid_nominal_gdp));
    else
        warning('Column Nominal_GDP is missing from the table.');
    end

    % Display a sample of the log-transformed data as a check
    disp('Sample of log-transformed data:');
    disp(data_log(1:min(5, height(data_log)), :)); % Display first 5 rows as sample
end
