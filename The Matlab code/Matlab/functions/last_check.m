function data_log = last_check(data_log, data_type, required_years)
    % Calculate the minimum number of rows needed based on data type and required years
    % an other fail safe
    switch lower(data_type)
        case 'annual'
            required_rows = required_years;
        case 'quarterly'
            required_rows = required_years * 4;
        case 'monthly'
            required_rows = required_years * 12;
        otherwise
            error('Unknown data type. Please specify "annual", "quarterly", or "monthly".');
    end

    fprintf('Checking each country''s data: Data type is %s, requiring at least %d years (%d rows minimum).\n', ...
        data_type, required_years, required_rows);

    % Get all country keys
    country_keys = keys(data_log);
    % Initialize list to store removed countries
    removed_countries = {};
    initial_count = length(country_keys);

    % Iterate through each country's data
    for i = 1:initial_count
        country = country_keys{i};
        ts_data = data_log(country);

        % Check if the number of rows is less than the required minimum
        if height(ts_data) < required_rows
            fprintf('Removing country with less than %d rows: %s\n', required_rows, country);
            % Record removed country
            removed_countries{end+1} = country;
            % Remove this country from the dataset
            remove(data_log, country);
        end
    end

    % Display results after the check
    remaining_keys = keys(data_log); % Get the remaining countries after the check
    fprintf('\nNumber of countries remaining after check: %d\n', length(remaining_keys));
    fprintf('Number of countries removed: %d\n', length(removed_countries));

    % Show the list of removed countries, if any
    if ~isempty(removed_countries)
        fprintf('List of removed countries:\n');
        disp(removed_countries');
    else
        fprintf('No countries were removed.\n');
    end
end
