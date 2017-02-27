%% Build supervised dataset
% Comment: Combine measurements from vehicles and weather station.
% The dataset is labeled and stores measurements each hour from the 
% last four hours (by default)

loop = 30
% Define constants used throughout this code
DefineConstants(loop);

% Load data from the measurements done by the weather stations
LoadWeatherData('SMHITemp.csv')

% Load data from vagverket
LoadWeatherDataVV('query_weatherstation_save_1435.csv')

% Generate fake friciton values
GenerateFakeFrictionValues();

% Remove all unwanted data inputs
ClearDataSet();

% Here we can change the data for doing special plots or debugging etc...
ManupulateDataForDebugging();

% Save the data set to the disk and matlab workspace
SaveData('cleareddataset',loop)

