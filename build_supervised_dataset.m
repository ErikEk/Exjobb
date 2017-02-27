%% Build supervised dataset
% Comment: Combine measurements from vehicles and weather station.
% The dataset is labeled and stores measurements each hour from the 
% last four hours (by default)

global newdataset nummins
%% For extracting different setups
for loop = 120:30:120
    
    
    % Define constants used throughout this code
    DefineConstants(loop);
    
    newdataset = zeros(fix(nummins),64);
    
    % Load data from the car data
    LoadCarData('frication_values.csv');
    
    % Load data from the measurements done by the weather stations
    LoadWeatherData('SMHITemp.csv')

    % Load data from vagverket
    LoadWeatherDataVV('query_weatherstation_save_1435.csv')

    % Remove all unwanted data inputs
    ClearDataSet();

    % Here we can change the data for doing special plots or debugging etc...
    ManupulateDataForDebugging();

    % Save the data set to the disk and matlab workspace
    SaveData('cleareddataset',loop)
end


