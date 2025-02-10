function filtered_table = filter_countries(data_table, country_list)
    % Extract the 'Country' column from the data table
    country_column = data_table.Country;
    
    % Initialize a logical index array
    is_country = false(height(data_table), 1);
    
    % Loop through the country column and mark true if the entry is in the country list
    for i = 1:length(country_column)
        if any(strcmp(country_list, country_column{i}))
            is_country(i) = true;
        end
    end
    
    % Filter the data table based on the is_country logical index
    filtered_table = data_table(is_country, :);
end
