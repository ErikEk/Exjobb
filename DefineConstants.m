function DefineConstants(offset_loop)

global nummins starttime formatIn formatIn2 formatIn3 inc_min_step offset_time current current_end min_quality 
global search_region max_search_time prev_time alldataset dataset step_behind newdataset
global indFrictionValue indFrictionQuality ind1PrevDistFriction ind1PrevTimeFriction ind1PrevFrictionValue ind1PrevFrictionQuality
global indTempSMHI indTempRoadVV indTempVV indHumidityVV indDewVV indRainVV indSnowVV indWindVV indWiperSpeedCar indLog
global indLat indMappedLog indMappedLat ind2PrevDistFriction ind2PrevTimeFriction ind2PrevFrictionValue ind3PrevDistFriction
global ind3PrevTimeFriction ind3PrevFrictionValue indTempCar



%% Define date/time format
formatIn = 'yyyy-mm-dd HH:MM:SS';
formatIn2 = 'dd-mmm-yyyy HH:MM:SS';
formatIn3 = 'mm/dd/yyyy HH:MM';

% Set start and end date/time
starttime = '2015-11-01 14:44:06';
endtime = '2016-11-15 06:06:07';
% Important variables with deafult values:

% Step size (in minutes)
inc_min_step = 30
% Duration until last measurement
prev_time = 60
% Set offset, this defines the forecast model (30 min, 60 min, 90 min...)
offset_time = offset_loop
% Set minimum quality level
min_quality = 4
% Set maximum duration since last measurement in hours
max_search_time = 5
% Set search region (for prev. measured friction values)
search_region = 0.04


% Error check
if inc_min_step > prev_time
    error('Cannot handle prev_time time larger then inc_step')
end

% Get the start and end dates in serial date number
step_behind = prev_time/inc_min_step;
firsttimemark = datenum(starttime,formatIn);
current = datenum(starttime,formatIn);
lasttime = datenum(endtime,formatIn);

% Show start and end date/time
disp('Start time')
datestr(current,formatIn)
disp('End time')
datestr(lasttime,formatIn)


t1 = datevec(firsttimemark);
t2 = datevec(lasttime);
% Get number of time intervals from start to end date/time
nummins = etime(t2,t1)/60/inc_min_step;

%% Feature Index
% These are the indices for the different features
indFrictionValue = 3;
indFrictionQuality = 4;

ind1PrevDistFriction = 5;
ind1PrevTimeFriction = 6;
ind1PrevFrictionValue = 7;
ind1PrevFrictionQuality = 65;

indTempSMHI = 9;
indTempRoadVV = 14;
indTempVV = 19;
indHumidityVV = 24;
indDewVV = 29;
indRainVV = 34;
indSnowVV = 39;
indWindVV = 44;
indWiperSpeedCar = 49;
indLog = 54;
indLat = 55;
indMappedLog = 56;
indMappedLat = 57;

ind2PrevDistFriction = 58;
ind2PrevTimeFriction = 59;
ind2PrevFrictionValue = 60;
ind3PrevDistFriction = 61;
ind3PrevTimeFriction = 62;
ind3PrevFrictionValue = 63;
indTempCar = 64;


%% Generate time marks

current = datenum(starttime,formatIn);

for mins=1:nummins
    current_end = addtodate(current, inc_min_step, 'minute');
    newdataset(mins,1) = current;
    % Update the time mark
    current = current_end;
end