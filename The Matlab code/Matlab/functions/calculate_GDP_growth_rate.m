function data_log = calculate_GDP_growth_rate(data_log)
    % Get the country keys
    country_keys = keys(data_log);

    % Loop through all countries and calculate the nominal GDP growth rate
    for i = 1:length(country_keys)
        country = country_keys{i};
        fprintf('Calculating the Nominal GDP growth rate for: %s\n', country);
        
        % Get the current country's data
        ts_data = data_log(country);
        
        % Calculate the Nominal GDP growth rate and store it
        ts_data.Nominal_GDP_growth_rate = [NaN; diff(ts_data.Nominal_GDP) ./ ts_data.Nominal_GDP(1:end-1)];
        
        % Save the updated data back to the map
        data_log(country) = ts_data;
    end

    % Remove the 'Country' column if it exists
    for i = 1:length(country_keys)
        country = country_keys{i};
        ts_data = data_log(country);
        if ismember('Country', ts_data.Properties.VariableNames)
            ts_data = removevars(ts_data, 'Country');
            data_log(country) = ts_data;
        end
    end

    % Remove rows with NaN in 'Nominal_GDP_growth_rate'
    for i = 1:length(country_keys)
        country = country_keys{i};
        ts_data = data_log(country);
        
        % Remove rows where 'Nominal_GDP_growth_rate' is NaN
        ts_data = ts_data(~isnan(ts_data.Nominal_GDP_growth_rate), :);
        data_log(country) = ts_data;
    end

    % Display the first country's data to verify results
    disp(data_log(country_keys{1}));
end