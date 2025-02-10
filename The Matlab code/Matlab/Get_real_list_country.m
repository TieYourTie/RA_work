% script_get_un_recognized_countries.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to extract UN-recognized countries based on ISO codes and save 
% the result to a .mat file for later use.
%
% Requirements:
%   - Ensure that 'UN_AE_LDC_HPIC_SIDS_LLDC_OECD_EIU.xlsx' file is in 
%     the specified data folder.
%
% Outputs:
%   - recognized_countries.mat: A .mat file containing the table of 
%     countries recognized by the UN.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the cutoff year
cutoff_year = 2020;  % Replace with the year you want as the cutoff

%define the work direction

% Get the current working directory
current_folder = pwd;

% Set the data folder path
data_folder = fullfile(current_folder, 'data');

% Set the functions folder path and add it to the search path
functions_folder = fullfile(current_folder, 'functions');
addpath(functions_folder);

% 设置参数
%data_folder = 'p';  % 指定存储 UN 文件的文件夹路径
%Iso_column = 'ISO_code';  % ISO 代码列的名称，确保与文件中的名称匹配

% Set the file path
WB_data_file = fullfile(data_folder, 'WB_data_pr.xlsx');

% 定义 UN 认可国家列表文件的路径
UN_list = fullfile(data_folder, 'UN_AE_LDC_HPIC_SIDS_LLDC_OECD_EIU.xlsx');

% 检查文件是否存在
if ~isfile(UN_list)
    error('The UN list file does not exist at the specified path.');
end

% 读取 UN 认可国家的数据
countries_list_UN = readtable(UN_list);

% 筛选出 UN 列为 1 的记录
recognized_countries = countries_list_UN(countries_list_UN.UN == 1, :);

% 移除缺失的 ISO 代码行
recognized_countries = recognized_countries(~ismissing(recognized_countries.(iso_column)), :);

% 保存为 .mat 文件
save('recognized_countries.mat', 'recognized_countries');
disp('联合国认可的国家数据已保存到 recognized_countries.mat 文件');
