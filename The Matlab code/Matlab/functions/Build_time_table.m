function ts_list = Build_time_table(data, year_limit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build a map of time series data for each unique country.
%
% Parameters:
% data - The input dataset with columns 'Country_Name' and 'TIME_PERIOD'
% year_limit - The maximum year to include in the data (e.g., 2020)
%
% Returns:
% ts_list - A map containing time series data for each country
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Extract unique countries from the data
    countries = unique(data.Country_Name);
    
    % Initialize an empty map to store time series data
    ts_list = containers.Map();
    
    % Loop through each country and process its time series data
    for i = 1:length(countries)
        country = countries{i};
        fprintf('Processing country: %s\n', country);
        
        % Filter the dataset for the current country and limit by year
        % The other failsafe if you are not run the data filter!
        % Tie - 11/15/2024
        country_data = data(strcmp(data.Country_Name, country), :);
        country_data = country_data(country_data.year<= year_limit, :);
        
        % Generate and store the time series data for the current country
        ts_list(country) = create_ts(country_data);
    end
end
