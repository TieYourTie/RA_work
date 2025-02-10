function final_data = stage_one_regression(data, type, type_two)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % stage_one_regression - Performs the first-stage regression analysis
    % Inputs:
    %   data - A containers.Map holding time series data for each country
    %   type - Type of analysis: 'HP' or 'QD'
    %   type_two - Specifies the secondary dataset to be used: 'WB', 'UN', 'IFS', or 'OECD'
    % Output:
    %   final_data - A table containing regression results for each country
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get the list of country keys
    country_keys = keys(data);
    num_countries = length(country_keys);
    
    % Initialize cell array to store regression results
    stage_one_regression_results = cell(num_countries, 4);
    
    % Collect data and perform regression for each country
    for i = 1:num_countries
        country = country_keys{i};
        ts_data = data(country);
        
        % Check if there is enough data for regression
        if height(ts_data) < 3
            warning('Not enough data for country: %s', country);
            continue;
        end
        
        % Set up dependent variable based on specified type
        if strcmp(type, 'HP')
            Y = ts_data.HP_cycle_log_real_GDP(2:end);  % HP model type
        elseif strcmp(type, 'QD')
            Y = ts_data.QD_detrended_log_real_GDP(2:end);  % QD model type
        else
            error('Invalid type specified. Use ''HP'' or ''QD''.');
        end
        X = ts_data.Nominal_GDP_growth_rate(1:end);  % Exogenous variable

        % Define the ARIMAX model structure with AR(1) and no constant term
        stage_one_model = arima('ARLags', 1, 'Constant', 0, 'Distribution', 'Gaussian');
        
        % Attempt to fit the ARIMAX model
        try
            EstMdl = estimate(stage_one_model, Y, 'X', X);
        catch ME
            warning('Estimation failed for country: %s. Error message: %s', country, ME.message);
            continue;
        end
        
        % Extract estimated parameters
        phi = EstMdl.AR{1};  % Autoregressive coefficient
        beta = EstMdl.Beta;  % Exogenous variable coefficient
        
        % Store regression results
        stage_one_regression_results{i, 1} = country;
        stage_one_regression_results{i, 2} = ts_data.ISO_code{1};
        stage_one_regression_results{i, 3} = phi;
        stage_one_regression_results{i, 4} = beta;
    end
    
    % Convert results to a table with specified column names
    stage_one_regression_results_table = cell2table(stage_one_regression_results, ...
        'VariableNames', {'Country', 'ISO_code', 'Persistence', 'Impact'});

    % Load additional data based on `type_two` selection
    switch type_two
        case 'WB'
            secondary_data = readtable('WB_average.csv');
        case 'UN'
            secondary_data = readtable('UN_average.csv');
        case 'IFS'
            secondary_data = readtable('IFS_average.csv');
        case 'OECD'
            secondary_data = readtable('OECD_average.csv');
        otherwise
            error('Invalid type_two specified. Use ''WB'', ''UN'', ''IFS'', or ''OECD''.');
    end

    % Load UN-related data to filter and match by ISO code
    un_data = readtable('UN_AE_LDC_HPIC_SIDS_LLDC_OECD_EIU.xlsx');
    
    % Step 1: Merge stage one regression results with `secondary_data` based on `ISO_code`
    merged_data = innerjoin(stage_one_regression_results_table, secondary_data, 'Keys', 'ISO_code');

    % Step 2: Further merge `merged_data` with `un_data` based on `ISO_code`
    final_data = innerjoin(merged_data, un_data, 'Keys', 'ISO_code');
    
    % Select and organize the necessary columns
    final_data = final_data(:, {'Country', 'ISO_code', 'Persistence', 'Impact', ...
                                'AverageInflation', 'AverageInflationSquared', 'AveragePopulationGrowth', ...
                                'UN', 'AE', 'LDC', 'HPIC', 'SIDS', 'LLDC', 'OECD', 'EIU'});
    
    % Remove rows with NaN in critical variables and eliminate duplicates
    final_data = final_data(~isnan(final_data.Persistence) & ~isnan(final_data.Impact), :);
    final_data = unique(final_data, 'rows');
    
    % Display the final table of results
    disp(final_data);
end 