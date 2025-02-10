function data_log_HP_QD = HP_QD_data(data_log, smoothing_factor)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Function to Detrend GDP and Inflation Data using HP Filter and 
    % Quadratic Detrending.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Inputs:
    %   - data_log: a struct containing time series data for each country
    %   - smoothing_factor: smoothing factor for the HP filter
    %
    % Outputs:
    %   - data_log_HP_QD: updated struct with detrended GDP and inflation data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get list of countries (keys) from data_log
    country_keys = keys(data_log);

    % 1. HP Filter to Detrend GDP Data
    for i = 1:length(country_keys)
        country = country_keys{i};
        fprintf('Applying HP filter to GDP data for country: %s\n', country);
        
        % Retrieve time series data for the current country
        ts_data = data_log(country);
        
        % Apply HP filter to nominal and real GDP data
        [trend_nominal, cycle_nominal] = hpfilter(ts_data.log_Nominal_GDP, 'Smoothing', smoothing_factor);
        [trend_real, cycle_real] = hpfilter(ts_data.log_Real_GDP, 'Smoothing', smoothing_factor);
        
        % Store the cyclical components in the dataset
        ts_data.HP_cycle_log_nominal_GDP = cycle_nominal;
        ts_data.HP_cycle_log_real_GDP = cycle_real;
        
        % Update the data_log struct with modified GDP data
        data_log(country) = ts_data;
    end
    
    % Display the first country's data for verification
    disp(data_log(country_keys{1}));

    % 2. Quadratic Detrending of Real GDP Data
    for i = 1:length(country_keys)
        country = country_keys{i};
        fprintf('Applying quadratic detrending to Real GDP data for country: %s\n', country);
        
        % Retrieve time series data for the current country
        ts_data = data_log(country);
        
        % Set up time index and quadratic trend design matrix
        time_index = (1:height(ts_data))';
        X = [ones(size(time_index)), time_index, time_index.^2];
        y = ts_data.log_Real_GDP;
        
        % Calculate trend component via quadratic fitting
        coeffs = X \ y;
        trend_component = X * coeffs;
        
        % Detrend data by removing the quadratic trend component
        ts_data.QD_detrended_log_real_GDP= y - trend_component;
        
        % Update the data_log struct with detrended Real GDP data
        data_log(country) = ts_data;
    end
    
    % Display the first country's data for verification
    disp(data_log(country_keys{1}));

    % 3. HP Filter for Inflation Data
    for i = 1:length(country_keys)
        country = country_keys{i};
        fprintf('Applying HP filter to inflation data for country: %s\n', country);
        
        % Retrieve time series data for the current country
        ts_data = data_log(country);
        
        % Apply HP filter to the inflation rate data
        inflation_rate = ts_data.Inflation_Rate;
        [trend_component, cyclical_component] = hpfilter(inflation_rate, 'Smoothing', smoothing_factor);
        
        % Store the trend and cyclical components in the dataset
        ts_data.HP_trend_Inflation_Rate_USD = trend_component;
        ts_data.HP_cycle_Inflation_Rate_USD = cyclical_component;
        
        % Update the data_log struct with detrended inflation data
        data_log(country) = ts_data;
    end
    
    % Display the first country's data for verification
    disp(data_log(country_keys{1}));

    % Output assignment
    data_log_HP_QD = data_log;
end
