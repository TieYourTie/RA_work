function Data_filtered = preprocess_raw_data(raw_data, cutoff_year, inflation_threshold)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function preprocesses data based on specified parameters.
    % Inputs:
    %   - raw_data: The raw data table (any dataset with a 'year' and 'Country_Name' or similar identifier)
    %   - cutoff_year: The cutoff year for filtering
    %   - inflation_threshold: The maximum allowed average inflation rate for a country
    % Output:
    %   - Data_filtered: The processed and filtered data table
    %
    % Specify the variables to retain, modifying this if needed for other datasets
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % note: for the future people, please do not change this line of code
    % as the rest of data processing code are based on the same factor. 
    variables = {'year', 'Country_Name', 'ISO_code', 'Real_GDP', 'Nominal_GDP', 'Inflation_Rate', 'Population_growth_rate'};
    
    % Step 1: Select specified variables if they exist in the data
    if all(ismember(variables, raw_data.Properties.VariableNames))
        % Keep only the variables that exist in raw_data
        variables = variables(ismember(variables, raw_data.Properties.VariableNames));
    else
        % Print a warning message
        disp('Warning: You do not have the required variables, please double check');
    end

    % Assign to Data_filtered to ensure it is returned
    Data_filtered = raw_data(:, variables);  

    % Step 2: Remove any rows with missing values
    Data_filtered = rmmissing(Data_filtered);

    % Step 3: Filter by cutoff year
    if ismember('year', Data_filtered.Properties.VariableNames)
        Data_filtered = Data_filtered(Data_filtered.year <= cutoff_year, :);
    end

    % Step 4: Remove countries with fewer than 25 years of data
    if ismember('Country_Name', Data_filtered.Properties.VariableNames)
        group_counts = varfun(@numel, Data_filtered, 'GroupingVariables', 'Country_Name', 'InputVariables', 'year');
        groups_to_keep = group_counts.Country_Name(group_counts.numel_year >= 25);
        Data_filtered = Data_filtered(ismember(Data_filtered.Country_Name, groups_to_keep), :);

        % Identify and display removed groups
        removed_groups = setdiff(group_counts.Country_Name, groups_to_keep);
        removed_count = numel(removed_groups);

        if removed_count > 0
            disp(['Number of groups removed due to insufficient data: ', num2str(removed_count)]);
            disp('Groups removed:');
            disp(removed_groups);
        else
            disp('No groups were removed! good job mate!');
        end
    else
        warning('No "Country_Name" or similar grouping variable found. Skipping group filtering.');
    end

    % Step 5: Calculate the average inflation rate for each country
    if ismember('Inflation_Rate', Data_filtered.Properties.VariableNames)
        avg_inflation = varfun(@mean, Data_filtered, 'GroupingVariables', 'Country_Name', 'InputVariables', 'Inflation_Rate');

        % Filter countries based on the average inflation threshold
        countries_to_keep = avg_inflation.Country_Name(avg_inflation.mean_Inflation_Rate <= inflation_threshold);
        Data_filtered = Data_filtered(ismember(Data_filtered.Country_Name, countries_to_keep), :);

        % Identify and display removed groups based on inflation
        inflation_removed_groups = setdiff(avg_inflation.Country_Name, countries_to_keep);
        inflation_removed_count = numel(inflation_removed_groups);

        if inflation_removed_count > 0
            disp(['Number of groups removed due to high inflation: ', num2str(inflation_removed_count)]);
            disp('Groups removed due to high inflation:');
            disp(inflation_removed_groups);
        else
            disp('No groups were removed due to inflation.');
        end
    else
        warning('No "Inflation_Rate" variable found. Skipping inflation filtering.');
    end

    % Display the total number of countries left in the dataset
    if ismember('Country_Name', Data_filtered.Properties.VariableNames)
        unique_countries = unique(Data_filtered.Country_Name);
        disp(['Total number of countries left in the dataset: ', num2str(numel(unique_countries))]);
    end

    % Display first few rows of the processed table
    disp('First few rows of the processed table:');
    disp(head(Data_filtered));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data filter function update notes
% 0.1: Initial function created.
% 0.2: Updated warning system to scream if the dataset is missing something.
% 0.3: Added inflation filtering based on average inflation threshold.
% 0.4: Added display of total number of countries left in the dataset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
