function EIU_statistics(data, OECD, targetVariable)
    % EIU Function to process data and run regression models with OECD filtering
    % Arguments:
    %   data: A table containing the required variables (Persistence, AverageInflation, Impact, EIU, Country, OECD)
    %   OECD: Specify 1 or 0 to filter data for OECD countries; if empty, use all data
    %   targetVariable: Specify 'Persistence' or 'Impact' for regression

    % Step 1: Extract Variables
    Persistence = data.Persistence;
    AverageInflation = data.AverageInflation;
    Impact = data.Impact;
    EIU = data.EIU;
    Country = data.Country;
    OECD_data = data.OECD;

    % Step 2: Handle Missing Data
    validData = ~isnan(Persistence) & ~isnan(AverageInflation) & ~isnan(Impact) & ~isnan(EIU) & ~isnan(OECD_data);
    Persistence = Persistence(validData);
    AverageInflation = AverageInflation(validData);
    Impact = Impact(validData);
    EIU = EIU(validData);
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
    EIU = EIU(filterIdx);
    Country = Country(filterIdx);

    % Check for Empty Filtered Data
    if isempty(Persistence) || isempty(AverageInflation) || isempty(Impact) || isempty(EIU)
        warning('Filtered data is empty. Defaulting to all data.');
        validData = ~isnan(Persistence) & ~isnan(AverageInflation) & ~isnan(Impact) & ~isnan(EIU);
        Persistence = data.Persistence(validData);
        AverageInflation = data.AverageInflation(validData);
        Impact = data.Impact(validData);
        EIU = data.EIU(validData);
        Country = data.Country(validData);
    end

    % Step 4: Calculate Summary Statistics
    numCountries = length(Country);
    avgInflation = mean(AverageInflation);
    avgPersistence = mean(Persistence);
    avgImpactEffect = mean(Impact);
    avgEIU = mean(EIU);

    % Display Summary Statistics
    disp('Summary Statistics:');
    fprintf('Number of Countries: %d\n', numCountries);
    fprintf('Average Inflation: %.2f\n', avgInflation);
    fprintf('Average Persistence: %.2f\n', avgPersistence);
    fprintf('Average Impact Effect: %.2f\n', avgImpactEffect);
    fprintf('Average EIU: %.2f\n', avgEIU);

    % Step 5: Fit the Model
    if strcmpi(targetVariable, 'Persistence')
        % Regression Model: Persistence ~ AverageInflation + EIU + AverageInflation * EIU
        X = [AverageInflation, EIU, AverageInflation .* EIU];
        y = Persistence;
        mdl = fitlm(X, y, 'linear');
        
        % Display Regression Results
        disp('Regression Model: Persistence ~ AverageInflation + EIU + AverageInflation * EIU');
        disp(mdl);
    elseif strcmpi(targetVariable, 'Impact')
        % Regression Model: Impact ~ AverageInflation + EIU + AverageInflation * EIU
        X = [AverageInflation, EIU, AverageInflation .* EIU];
        y = Impact;
        mdl = fitlm(X, y, 'linear');
        
        % Display Regression Results
        disp('Regression Model: Impact ~ AverageInflation + EIU + AverageInflation * EIU');
        disp(mdl);
    else
        error('Invalid target variable. Specify "Persistence" or "Impact".');
    end
end
