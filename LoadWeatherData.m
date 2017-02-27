function LoadWeatherData(filename)

    global nummins starttime formatIn formatIn2 formatIn3 inc_min_step offset_time current current_end min_quality 
    global search_region max_search_time prev_time dataset newdataset step_behind
    global indFrictionValue indFrictionQuality ind1PrevDistFriction ind1PrevTimeFriction ind1PrevFrictionValue ind1PrevFrictionQuality
    global indTempSMHI indTempRoadVV indTempVV indHumidityVV indDewVV indRainVV indSnowVV indWindVV indWiperSpeedCar indLog
    global indLat indMappedLog indMappedLat ind2PrevDistFriction ind2PrevTimeFriction ind2PrevFrictionValue ind3PrevDistFriction
    global ind3PrevTimeFriction ind3PrevFrictionValue indTempCar 
    global raw_temp
    
	%% ADD Temperature data from SMHI
	ftemp = fopen('SMHITemp.csv','rt');
	raw_temp = textscan(ftemp, ['%f %s %s ',repmat('%f',[1,1])],'Delimiter',',','headerLines', 0); %or whatever formatting your file is
	fclose(ftemp);


	%% Create datetime list in raw_temp
	% Reformat the time stamp
	disp('Create datetime list in raw_temp...')
	numtemphours = length(raw_temp{1}(:));
	for temphours=1:numtemphours
	    if mod(temphours,200) == 0
	        fprintf('%.2f %% done\n',temphours/numtemphours*100);
	    end
	    raw_temp{5}(temphours) = datenum([...
	        strjoin(raw_temp{2}(temphours)) ' ' strjoin(raw_temp{3}(temphours))],...
	        formatIn);
	end

	%% Load data from SMHI
	disp('Load temperatures from SMHI dataset...')
	% Dummy optimizer variable
	lowestIndex = 2;

	% Loop through all time intervals
    for mins=1:nummins
	    
	    % Progress output
	    if mod(mins,40) == 0
	        fprintf('%.2f %% done\n',mins/nummins*100);
	    end
	    
	    % Set an offset, used to build datasets for the forecast models
	    current_offset = addtodate(newdataset(mins,1), -offset_time, 'minute');
	    datestr(newdataset(mins,1));
	    for temphours=lowestIndex:numtemphours-1
	        
            % Optimize the search algorithm
            if current_offset < raw_temp{5}(temphours)
                break
            end
            if raw_temp{5}(temphours) < current_offset
                lowestIndex = temphours;
            end

            % Find matching measurement
            if (current_offset >= raw_temp{5}(temphours)) && ...
               (current_offset < raw_temp{5}(temphours+1))
                newdataset(mins,indTempSMHI) = raw_temp{4}(temphours);
            end
        end
    end
    
    size(newdataset)
	indTempSMHI
    step_behind
    
	%% Store previous temperatures (SMHI)
	newdataset(:,indTempSMHI+1) = [zeros(step_behind*1,1);newdataset(1:end-step_behind*1,indTempSMHI)];
    newdataset(:,indTempSMHI+2) = [zeros(step_behind*2,1);newdataset(1:end-step_behind*2,indTempSMHI)];
	newdataset(:,indTempSMHI+3) = [zeros(step_behind*3,1);newdataset(1:end-step_behind*3,indTempSMHI)];
	newdataset(:,indTempSMHI+4) = [zeros(step_behind*4,1);newdataset(1:end-step_behind*4,indTempSMHI)];

end