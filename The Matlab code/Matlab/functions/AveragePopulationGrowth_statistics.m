function AveragePopulationGrowth_statistics(data, OECD, targetVariable)
    % Function to process data and run regression models with OECD filtering
    % Arguments:
    %   data: A table containing the required variables (Persistence, AverageInflation, Impact, AveragePopulationGrowth, Country, OECD)
    %   OECD: Specify 1 or 0 to filter data for OECD countries; if empty, use all data
    %   targetVariable: Specify 'Persistence' or 'Impact' for regression

    % Step 1: Extract Variables
    Persistence = data.Persistence;
    AverageInflation = data.AverageInflation;
    Impact = data.Impact;
    AveragePopulationGrowth = data.AveragePopulationGrowth;
    Country = data.Country;
    OECD_data = data.OECD;

    % Step 2: Handle Missing Data
    validData = ~isnan(Persistence) & ~isnan(AverageInflation) & ~isnan(Impact) & ~isnan(AveragePopulationGrowth) & ~isnan(OECD_data);
    Persistence = Persistence(validData);
    AverageInflation = AverageInflation(validData);
    Impact = Impact(validData);
    AveragePopulationGrowth = AveragePopulationGrowth(validData);
    Country = Country(validData);
    OECD_data = OECD_data(validData);

    % Step 3: Filter by OECD
    if OECD == 1
        filterIdx = OECD_data == 1;
        disp('Filtering data for OECD = 1 countries.');
    elseif OECD == 0
        filterIdx = OECD_data == 0;
        disp('Filtering data for OECD = 0 countries.');
    else
        filterIdx = true(size(OECD_data));
        disp('No valid OECD filter specified. Using all data.');
    end

    % Apply Filter
    Persistence = Persistence(filterIdx);
    AverageInflation = AverageInflation(filterIdx);
    Impact = Impact(filterIdx);
    AveragePopulationGrowth = AveragePopulationGrowth(filterIdx);
    Country = Country(filterIdx);

    % Check for Empty Filtered Data
    if isempty(Persistence) || isempty(AverageInflation) || isempty(Impact) || isempty(AveragePopulationGrowth)
        warning('Filtered data is empty. Defaulting to all data.');
        validData = ~isnan(Persistence) & ~isnan(AverageInflation) & ~isnan(Impact) & ~isnan(AveragePopulationGrowth);
        Persistence = data.Persistence(validData);
        AverageInflation = data.AverageInflation(validData);
        Impact = data.Impact(validData);
        AveragePopulationGrowth = data.AveragePopulationGrowth(validData);
        Country = data.Country(validData);
    end

    % Step 4: Calculate Summary Statistics
    numCountries = length(Country);
    avgInflation = mean(AverageInflation);
    avgPersistence = mean(Persistence);
    avgImpactEffect = mean(Impact);
    avgPopulationGrowth = mean(AveragePopulationGrowth);

    % Display Summary Statistics
    disp('Summary Statistics:');
    fprintf('Number of Countries: %d\n', numCountries);
    fprintf('Average Inflation: %.2f\n', avgInflation);
    fprintf('Average Persistence: %.2f\n', avgPersistence);
    fprintf('Average Impact Effect: %.2f\n', avgImpactEffect);
    fprintf('Average Population Growth: %.2f\n', avgPopulationGrowth);

    % Step 5: Fit the Model
    if strcmpi(targetVariable, 'Persistence')
        % Regression Model: Persistence ~ AverageInflation + AveragePopulationGrowth + AverageInflation * AveragePopulationGrowth
        X = [AverageInflation, AveragePopulationGrowth, AverageInflation .* AveragePopulationGrowth];
        y = Persistence;
        mdl = fitlm(X, y, 'linear');
        
        % Display Regression Results
        disp('Regression Model: Persistence ~ AverageInflation + AveragePopulationGrowth + AverageInflation * AveragePopulationGrowth');
        disp(mdl);
    elseif strcmpi(targetVariable, 'Impact')
        % Regression Model: Impact ~ AverageInflation + AveragePopulationGrowth + AverageInflation * AveragePopulationGrowth
        X = [AverageInflation, AveragePopulationGrowth, AverageInflation .* AveragePopulationGrowth];
        y = Impact;
        mdl = fitlm(X, y, 'linear');
        
        % Display Regression Results
        disp('Regression Model: Impact ~ AverageInflation + AveragePopulationGrowth + AverageInflation * AveragePopulationGrowth');
        disp(mdl);
    else
        error('Invalid target variable. Specify "Persistence" or "Impact".');
    end
end
