function average_matrix = average_inflation_population_growth(data, mat_filename, csv_filename, inflation_threshold, growth_threshold)
    % Update the key
    country_keys = keys(data);
    
    % Start the table
    average_table = cell(length(country_keys), 5);

    for i = 1:length(country_keys)
        country = country_keys{i};
        
        % Load the data
        ts_data = data(country);

        % Calculate averages
        avg_inflation = mean(ts_data.Inflation_Rate, 'omitnan'); % Average inflation rate
        avg_inflation_squared = mean(ts_data.Inflation_Rate.^2, 'omitnan'); % Average squared inflation
        avg_population_growth = mean(ts_data.Population_growth_rate, 'omitnan'); % Average population growth rate
        
        % Save the results
        average_table{i, 1} = country;
        average_table{i, 2} = ts_data.ISO_code{1};
        average_table{i, 3} = avg_inflation;
        average_table{i, 4} = avg_inflation_squared;
        average_table{i, 5} = avg_population_growth;
    end

    % Convert cell to table
    average_inflation_table = cell2table(average_table, ...
        'VariableNames', {'Country_Name', 'ISO_code', 'AverageInflation', 'AverageInflationSquared', 'AveragePopulationGrowth'});

    % Apply filtering only if thresholds are provided
    if ~isempty(inflation_threshold)
        inflation_filter = average_inflation_table.AverageInflation <= inflation_threshold;
    else
        inflation_filter = true(height(average_inflation_table), 1); % No filtering
    end

    if ~isempty(growth_threshold)
        growth_filter = average_inflation_table.AveragePopulationGrowth <= growth_threshold;
    else
        growth_filter = true(height(average_inflation_table), 1); % No filtering
    end

    % Combine filters
    combined_filter = inflation_filter & growth_filter;

    % Apply the filter
    filtered_table = average_inflation_table(combined_filter, :);
    
    % Display the filtered averages
    disp('Filtered averages for each country:');
    disp(filtered_table);

    % Save the filtered data as a CSV file
    writetable(filtered_table, csv_filename);

    % Save the filtered data as a MAT file
    save(fullfile('Data', mat_filename), 'filtered_table', 'csv_filename');

    % Output the filtered table
    average_matrix = filtered_table;
end