%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%graphy for the IFS-HP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Setup and Data Loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the current working directory
current_folder = pwd;

% Set the data folder path
data_folder = fullfile(current_folder, 'data');

% Set the functions folder path and add it to the search path
functions_folder = fullfile(current_folder, 'functions');
addpath(functions_folder);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Load the data
data_HP = readtable('IFS_stage_one_regresison_HP.xlsx');

% Step 2: Extract relevant columns
Countries = data_HP.Country;
Persistence = data_HP.Persistence;
AverageInflation = data_HP.AverageInflation;
Impact = data_HP.Impact;

% Step 3: Identify duplicate entries and keep only the first occurrence
[~, uniqueIdx] = unique(Countries, 'first'); % Find the first occurrence of each country

% Step 4: Sort the indices to maintain the original order
uniqueIdx = sort(uniqueIdx);

% Step 5: Filter all related data to keep only unique entries
Countries = Countries(uniqueIdx);
Persistence = Persistence(uniqueIdx);
AverageInflation = AverageInflation(uniqueIdx);
Impact = Impact(uniqueIdx);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Extract Relevant Columns
Persistence = data_HP.Persistence;
AverageInflation = data_HP.AverageInflation;
Impact = data_HP.Impact;

Countries = data_HP.Country;

% Step 3: Handle Missing Data
validData = ~isnan(Persistence) & ~isnan(AverageInflation);
Persistence = Persistence(validData);
AverageInflation = AverageInflation(validData);
Countries = Countries(validData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate Summary Statistics
numCountries = length(Countries);
avgInflation = mean(AverageInflation);
avgPersistence = mean(Persistence);
avgImpactEffect = mean(Impact);


%  Fit a Linear Regression Line
coefficients = polyfit(AverageInflation, Persistence, 1); % Linear fit
fit_line = polyval(coefficients, AverageInflation); % Generate regression line

%  Perform Linear Regression
mdl = fitlm(AverageInflation, Persistence, 'linear'); % Fit linear model
coefficients = mdl.Coefficients.Estimate; % Extract coefficients
fit_line = predict(mdl, AverageInflation); % Generate fitted values

% Display regression results in command window
disp(mdl);

% Plot the Data and Regression Line
fig = figure('Name', 'IFS HP Persistence', 'NumberTitle', 'off'); % Set figure name
scatter(AverageInflation, Persistence, 'filled'); % Scatter plot
hold on;
plot(AverageInflation, fit_line, '-r', 'LineWidth', 2); % Regression line
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('Persistence vs. Average Inflation(IFS HP)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');
hold off;

% Add Country Names as Text Labels
hold on;
for i = 1:length(Countries)
    text(AverageInflation(i), Persistence(i), Countries{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end
hold off;

annotationText = sprintf('Number of Countries: %d\nAverage Inflation: %.2f\nAverage Persistence: %.2f', ...
    numCountries, avgInflation, avgPersistence);

% Position the annotation text dynamically
text_x = min(AverageInflation) + 0.05 * range(AverageInflation);
text_y = max(Persistence) - 0.1 * range(Persistence);

% Add annotation text to the plot
text(text_x, text_y, annotationText, ...
    'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IFS-HP-IMPACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 2: Extract Relevant Columns
Persistence = data_HP.Persistence;
AverageInflation = data_HP.AverageInflation;
Impact = data_HP.Impact;
OECD = data_HP.OECD;
Countries = data_HP.Country;

% Step 3: Handle Missing Data
validData = ~isnan(Impact) & ~isnan(AverageInflation);
Impact = Impact(validData);
AverageInflation = AverageInflation(validData);
Countries = Countries(validData);

% Step 4: Calculate Summary Statistics
numCountries = length(Countries);
avgInflation = mean(AverageInflation, 'omitnan'); % Mean inflation, omitting NaN values
avgImpactEffect = mean(Impact, 'omitnan'); % Mean impact effect

% Step 5: Perform Linear Regression
mdl = fitlm(AverageInflation, Impact, 'linear'); % Fit linear model
fit_line = predict(mdl, AverageInflation); % Generate fitted values

% Display regression results in command window
disp('Linear Regression Results:');
disp(mdl);

% Step 6: Plot the Data and Regression Line
fig = figure('Name', 'WB_HP_Impact_Effect', 'NumberTitle', 'off'); % Set figure name
scatter(AverageInflation, Impact, 'filled'); % Scatter plot
hold on;
plot(AverageInflation, fit_line, '-r', 'LineWidth', 2); % Regression line
xlabel('Average Inflation (%)');
ylabel('Impact');
title('Impact vs. Average Inflation (IFS HP)');Countries
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Step 7: Add Country Names as Text Labels
for i = 1:length(Countries)
    text(AverageInflation(i), Impact(i), Countries{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

% Step 8: Add Annotation with Summary Statistics
annotationText = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Impact: %.2f', ...
    numCountries, avgInflation, avgImpactEffect);

% Dynamically position the annotation text
text_x = min(AverageInflation) + 0.05 * range(AverageInflation);
text_y = max(Impact) - 0.1 * range(Impact);

% Add annotation text to the plot
text(text_x, text_y, annotationText, ...
    'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IFS-HP-OECD/non-OECD
    %IFS-HP-OECD
        %IFS-HP-OECD-PRESITENCE
        %IFS-HP-OECD-IMPACT
    %IFS-HP-nonOECD
        %IFS-HP-nonOECD-PRESITENCE
        %IFS-HP-nonOECD-IMPACT
       
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: Handle Missing Data
validData = ~isnan(Persistence) & ~isnan(AverageInflation) & ~isnan(OECD);
Persistence = Persistence(validData);
AverageInflation = AverageInflation(validData);
Impact = Impact(validData);
OECD = OECD(validData);
Countries = Countries(validData);

% Filter data for OECD = 1
oecd1_idx = OECD == 1;
Persistence_effect_OECD1 = Persistence(oecd1_idx);
AverageInflation_OECD1 = AverageInflation(oecd1_idx);
Impact_Effect_OECD1 = Impact(oecd1_idx);
Countries_OECD1 = Countries(oecd1_idx);


% Filter data for OECD = 0
oecd0_idx = OECD == 0;
Persistence_effect_OECD0 = Persistence(oecd0_idx);
AverageInflation_OECD0 = AverageInflation(oecd0_idx);
Impact_Effect_OECD0 = Impact(oecd0_idx);
Countries_OECD0 = Countries(oecd0_idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IFS-HP-OECD-PRESITENCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure('Name', 'WB_HP_Persistence_Effect_OECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD1, Persistence_effect_OECD1, 'filled');
hold on;

% Calculate linear fit
coefficients = polyfit(AverageInflation_OECD1, Persistence_effect_OECD1, 1);
fit_line = polyval(coefficients, AverageInflation_OECD1);
plot(AverageInflation_OECD1, fit_line, '-r', 'LineWidth', 2);

% Calculate statistics
num_countries = length(Countries_OECD1);
avg_inflation = mean(AverageInflation_OECD1, 'omitnan');
avg_persistence = mean(Persistence_effect_OECD1, 'omitnan');

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD1, Persistence_effect_OECD1, 'linear'); % Fit linear model
coefficients = mdl.Coefficients.Estimate; % Extract coefficients
fit_line = predict(mdl, AverageInflation); % Generate fitted values

% Display regression results in command window
disp(mdl);

% Add statistics to the plot
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Persistence: %.2f', ...
    num_countries, avg_inflation, avg_persistence);
text_x = min(AverageInflation_OECD1) + 0.05 * range(AverageInflation_OECD1);
text_y = max(Persistence_effect_OECD1) - 0.05 * range(Persistence_effect_OECD1);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Labels and title
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('Persistence vs. Average Inflation (IFS HP OECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add country names as labels
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Persistence_effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IFS-HP-OECD-IMPACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create figure and scatter plot
fig2 = figure('Name', 'WB_HP_Impact_Effect_OECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD1, Impact_Effect_OECD1, 'filled');
hold on;

% Perform linear fit and plot the regression line
coefficients = polyfit(AverageInflation_OECD1, Impact_Effect_OECD1, 1);
fit_line = polyval(coefficients, AverageInflation_OECD1);
plot(AverageInflation_OECD1, fit_line, '-r', 'LineWidth', 2);

% Calculate and display statistics
num_countries = length(Countries_OECD1);
avg_inflation = mean(AverageInflation_OECD1, 'omitnan');
avg_impact_effect = mean(Impact_Effect_OECD1, 'omitnan');

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD1, Impact_Effect_OECD1, 'linear'); % Fit linear model
% Display regression results in command window
disp(mdl);

% Add statistical annotations
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Impact: %.2f', ...
    num_countries, avg_inflation, avg_impact_effect);
text_x = min(AverageInflation_OECD1) + 0.05 * range(AverageInflation_OECD1);
text_y = max(Impact_Effect_OECD1) - 0.05 * range(Impact_Effect_OECD1);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Set plot labels and title
xlabel('Average Inflation (%)');
ylabel('Impact');
title('Impact vs. Average Inflation (IFS HP OECD)');
grid on;

% Add legend
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Annotate points with country names
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Impact_Effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 6: Plot Persistence vs Average Inflation (OECD = 0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %IFS-HP-nonOECD
        %IFS-HP-nonOECD-PRESITENCE
        %IFS-HP-nonOECD-IMPACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
% Create figure and scatter plot
fig3 = figure('Name', 'WB_HP_Persistence_Effect_nonOECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD0, Persistence_effect_OECD0, 'filled');
hold on;

% Perform linear fit and plot the regression line
coefficients = polyfit(AverageInflation_OECD0, Persistence_effect_OECD0, 1);
fit_line = polyval(coefficients, AverageInflation_OECD0);
plot(AverageInflation_OECD0, fit_line, '-r', 'LineWidth', 2);

% Calculate and display statistics
num_countries = length(Countries_OECD0);
avg_inflation = mean(AverageInflation_OECD0, 'omitnan');
avg_persistence = mean(Persistence_effect_OECD0, 'omitnan');

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD0, Persistence_effect_OECD0, 'linear'); % Fit linear model
% Display regression results in command window
disp(mdl);  

% Add statistical annotations
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Persistence: %.2f', ...
    num_countries, avg_inflation, avg_persistence);
text_x = min(AverageInflation_OECD0) + 0.05 * range(AverageInflation_OECD0);
text_y = max(Persistence_effect_OECD0) - 0.05 * range(Persistence_effect_OECD0);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Set plot labels and title
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('IFS HP Persistence vs. Average Inflation (IFS HP nonOECD)');
grid on;

% Add legend
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Annotate points with country names
for i = 1:length(Countries_OECD0)
    text(AverageInflation_OECD0(i), Persistence_effect_OECD0(i), Countries_OECD0{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IFS-HP-nonOECD-IMPACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create figure and scatter plot
fig4 = figure('Name', 'WB_HP_Impact_Effect_nonOECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD0, Impact_Effect_OECD0, 'filled');
hold on;

% Perform linear fit and plot regression line
coefficients = polyfit(AverageInflation_OECD0, Impact_Effect_OECD0, 1);
fit_line = polyval(coefficients, AverageInflation_OECD0);
plot(AverageInflation_OECD0, fit_line, '-r', 'LineWidth', 2);

% Calculate and display statistics
num_countries = length(Countries_OECD0);
avg_inflation = mean(AverageInflation_OECD0, 'omitnan');
avg_impact_effect = mean(Impact_Effect_OECD0, 'omitnan');

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD0, Impact_Effect_OECD0, 'linear'); % Fit linear model
% Display regression results in command window
disp(mdl);

% Add statistical annotations
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Impact: %.2f', ...
    num_countries, avg_inflation, avg_impact_effect);
text_x = min(AverageInflation_OECD0) + 0.05 * range(AverageInflation_OECD0);
text_y = max(Impact_Effect_OECD0) - 0.05 * range(Impact_Effect_OECD0);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Set plot labels and title
xlabel('Average Inflation (%)');
ylabel('Impact');
title('IFS HP Impact vs. Average Inflation (IFS HP nonOECD)');
grid on;

% Add legend
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Annotate points with country names
for i = 1:length(Countries_OECD0)
    text(AverageInflation_OECD0(i), Impact_Effect_OECD0(i), Countries_OECD0{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

hold off;

