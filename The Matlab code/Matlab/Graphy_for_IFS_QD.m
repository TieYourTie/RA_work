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

% Set the file path
IFS_data_file = fullfile(data_folder, 'IFS_data_pr.xlsx');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now its the time to do the QD graphy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %WB_QD
    % WB_QD_Persistence
    % WB_QD_Impact
    % WB_QD_OECD
        %WB_QD_OECD_persistence
        %WB_QD_OECD_impact
    % WB_QD_nonOECD
        %WB_QD_nonOECD_persistence
        %WB_QD_nonOECD_impact
        


%Step 1: lode the data
data_QD = readtable('IFS_stage_one_regresison_QD.xlsx');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Extract Relevant Columns
Persistence = data_QD.Persistence;
AverageInflation = data_QD.AverageInflation;
Impact = data_QD.Impact

Countries = data_QD.Country;Persistence

% Step 3: Handle Missing Data
validData = ~isnan(Persistence) & ~isnan(AverageInflation);
Persistence = Persistence(validData);
AverageInflation = AverageInflation(validData);
Countries = Countries(validData);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 4: Calculate Summary Statistics
numCountries = length(Countries);
avgInflation = mean(AverageInflation);
avgPersistence = mean(Persistence);
avgImpactEffect = mean(Impact)

% Step 5: Fit a Linear Regression Line
coefficients = polyfit(AverageInflation, Persistence, 1); % Linear fit
fit_line = polyval(coefficients, AverageInflation); % Generate regression line


% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation, Persistence, 'linear'); % Fit linear model


% Display regression results in command window
disp(mdl);

% Step 6: Plot the Data and Regression Line
fig = figure('Name', 'WB_QD_Persistence_Effect', 'NumberTitle', 'off'); % Set figure name
scatter(AverageInflation, Persistence, 'filled'); % Scatter plot
hold on;
plot(AverageInflation, fit_line, '-r', 'LineWidth', 2); % Regression line
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('Persistence vs. Average Inflation（IFS QD）');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');
hold off;

% Step 8: Add Country Names as Text Labels
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
% Step 2: Extract Relevant Columns
Persistence = data_QD.Persistence;
AverageInflation = data_QD.AverageInflation;
Impact = data_QD.Impact;
OECD = data_QD.OECD;
Countries = data_QD.Country;

% Step 3: Handle Missing Data
validData = ~isnan(Impact) & ~isnan(AverageInflation);
Impact = Impact(validData);
AverageInflation = AverageInflation(validData);
Countries = Countries(validData);

% Step 4: Calculate Summary Statistics
numCountries = length(Countries);
avgInflation = mean(AverageInflation);
avgImpactEffect = mean(Impact);

% Step 5: Fit a Linear Regression Line
coefficients = polyfit(AverageInflation, Impact, 1); % Linear fit
fit_line = polyval(coefficients, AverageInflation); % Generate regression line

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation, Impact, 'linear'); % Fit linear model

% Display regression results in command window
disp(mdl);
 
% Step 6: Plot the Data and Regression Line
fig = figure('Name', 'WB_QD_Impact_Effect', 'NumberTitle', 'off'); % Set figure name
scatter(AverageInflation, Impact, 'filled'); % Scatter plot
hold on;
plot(AverageInflation, fit_line, '-r', 'LineWidth', 2); % Regression line
xlabel('Average Inflation (%)');
ylabel('Impact');
title('IFS QD Impact vs. Average Inflation');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');
hold off;

% Step 8: Add Country Names as Text Labels
hold on;
for i = 1:length(Countries)
    text(AverageInflation(i), Impact(i), Countries{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end
hold off;

annotationText = sprintf('Number of Countries: %d\nAverage Inflation: %.2f\nAverage Persistence: %.2f', ...
    numCountries, avgInflation, avgPersistence);

% Position the annotation text dynamically
text_x = min(AverageInflation) + 0.05 * range(AverageInflation);
text_y = max(Impact) - 0.1 * range(Impact);

% Add annotation text to the plot
text(text_x, text_y, annotationText, ...
    'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now, the OECD and non OECD countries compare
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OECD = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 4: Plot Persistence vs Average Inflation (OECD = 1)
fig1 = figure('Name', 'WB_QD_Persistence_Effect_OECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD1, Persistence_effect_OECD1, 'filled');
hold on;
coefficients = polyfit(AverageInflation_OECD1, Persistence_effect_OECD1, 1);
fit_line = polyval(coefficients, AverageInflation_OECD1);
plot(AverageInflation_OECD1, fit_line, '-r', 'LineWidth', 2);
xlabel('Average Inflation (%)');
ylabel('Persistence');
title(' Persistence vs. Average Inflation (IFS QD OECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Persistence_effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end
hold off;


% Calculate statistics
num_countries = length(Countries_OECD1);
avg_inflation = mean(AverageInflation_OECD1, 'omitnan');
avg_persistence = mean(Persistence_effect_OECD1, 'omitnan');

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD1, Persistence_effect_OECD1, 'linear'); % Fit linear model
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
title('Persistence vs. Average Inflation (IFS QD OECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add country names as labels
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Persistence_effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 5: Plot Impact vs Average Inflation (OECD = 1)
fig2 = figure('Name', 'WB_QD_Impact_Effect_OECD', 'NumberTitle', 'off');
scatter(AverageInflation_OECD1, Impact_Effect_OECD1, 'filled');
hold on;

% Linear Fit
coefficients = polyfit(AverageInflation_OECD1, Impact_Effect_OECD1, 1);
fit_line = polyval(coefficients, AverageInflation_OECD1);
plot(AverageInflation_OECD1, fit_line, '-r', 'LineWidth', 2);

% Labels and Title
xlabel('Average Inflation (%)');
ylabel('Impact');
title('Impact vs. Average Inflation (IFS QD OECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add country names as labels
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Impact_Effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end
hold off;

% Step 4: Perform Linear Regression
mdl = fitlm(AverageInflation_OECD1, Impact_Effect_OECD1); % Fit linear model
disp(mdl); % Display regression results in the command window

% Calculate Statistics
num_countries = length(Countries_OECD1);
avg_inflation = mean(AverageInflation_OECD1, 'omitnan');
avg_impact = mean(Impact_Effect_OECD1, 'omitnan');

% Add Statistics to the Plot
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Impact: %.2f', ...
    num_countries, avg_inflation, avg_impact);
text_x = min(AverageInflation_OECD1) + 0.05 * range(AverageInflation_OECD1);
text_y = max(Impact_Effect_OECD1) - 0.05 * range(Impact_Effect_OECD1);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Labels and title
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('Persistence vs. Average Inflation (IFS QD OECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add country names as labels
for i = 1:length(Countries_OECD1)
    text(AverageInflation_OECD1(i), Persistence_effect_OECD1(i), Countries_OECD1{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OECD = 0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate statistics
num_countries = length(Countries_OECD0);
avg_inflation = mean(AverageInflation_OECD0, 'omitnan');
avg_persistence = mean(Persistence_effect_OECD0, 'omitnan');
avg_impact = mean(Impact_Effect_OECD0, 'omitnan');

%% Step 6: Plot Persistence vs Average Inflation (OECD = 0)
fig3 = figure('Name', 'Persistence_Effect_OECD_0', 'NumberTitle', 'off');
scatter(AverageInflation_OECD0, Persistence_effect_OECD0, 'filled');
hold on;

% Linear Fit
coefficients = polyfit(AverageInflation_OECD0, Persistence_effect_OECD0, 1);
fit_line = polyval(coefficients, AverageInflation_OECD0);
plot(AverageInflation_OECD0, fit_line, '-r', 'LineWidth', 2);

% Add Labels and Title
xlabel('Average Inflation (%)');
ylabel('Persistence');
title('Persistence vs. Average Inflation (IFS QD nonOECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add Country Names as Labels
for i = 1:length(Countries_OECD0)
    text(AverageInflation_OECD0(i), Persistence_effect_OECD0(i), Countries_OECD0{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

% Add Statistics to the Plot
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Persistence: %.2f', ...
    num_countries, avg_inflation, avg_persistence);
text_x = min(AverageInflation_OECD0) + 0.05 * range(AverageInflation_OECD0);
text_y = max(Persistence_effect_OECD0) - 0.05 * range(Persistence_effect_OECD0);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');
hold off;

% Perform Linear Regression
mdl_persistence = fitlm(AverageInflation_OECD0, Persistence_effect_OECD0, 'linear');
disp(mdl_persistence);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 7: Plot Impact vs Average Inflation (OECD = 0)
fig4 = figure('Name', 'Impact_Effect_OECD_0', 'NumberTitle', 'off');
scatter(AverageInflation_OECD0, Impact_Effect_OECD0, 'filled');
hold on;

% Linear Fit
coefficients = polyfit(AverageInflation_OECD0, Impact_Effect_OECD0, 1);
fit_line = polyval(coefficients, AverageInflation_OECD0);
plot(AverageInflation_OECD0, fit_line, '-r', 'LineWidth', 2);

% Add Labels and Title
xlabel('Average Inflation (%)');
ylabel('Impact');
title('Impact vs. Average Inflation (IFS QD nonOECD)');
grid on;
legend('Data Points', 'Linear Fit', 'Location', 'best');

% Add Country Names as Labels
for i = 1:length(Countries_OECD0)
    text(AverageInflation_OECD0(i), Impact_Effect_OECD0(i), Countries_OECD0{i}, ...
        'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
end

% Add Statistics to the Plot
stats_text = sprintf('Number of Countries: %d\nAverage Inflation: %.2f%%\nAverage Impact: %.2f', ...
    num_countries, avg_inflation, avg_impact);
text_x = min(AverageInflation_OECD0) + 0.05 * range(AverageInflation_OECD0);
text_y = max(Impact_Effect_OECD0) - 0.05 * range(Impact_Effect_OECD0);
text(text_x, text_y, stats_text, 'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');
hold off;

% Perform Linear Regression
mdl_impact = fitlm(AverageInflation_OECD0, Impact_Effect_OECD0, 'linear');
disp(mdl_impact);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
