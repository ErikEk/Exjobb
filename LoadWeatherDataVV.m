function y = LoadWeatherData(filename)

    global nummins starttime formatIn formatIn2 formatIn3 inc_min_step offset_time current current_end min_quality 
    global search_region max_search_time prev_time alldataset dataset newdataset step_behind
    global indFrictionValue indFrictionQuality ind1PrevDistFriction ind1PrevTimeFriction ind1PrevFrictionValue ind1PrevFrictionQuality
    global indTempSMHI indTempRoadVV indTempVV indHumidityVV indDewVV indRainVV indSnowVV indWindVV indWiperSpeedCar indLog
    global indLat indMappedLog indMappedLat ind2PrevDistFriction ind2PrevTimeFriction ind2PrevFrictionValue ind3PrevDistFriction
    global ind3PrevTimeFriction ind3PrevFrictionValue indTempCar
    
	%% ADD data from Vagverket
	fvv = fopen(filename,'rt');
	raw_vv = textscan(fvv, ['%f %f %s ',repmat('%f',[1,8]),' %s %f'],'Delimiter',',','headerLines', 0); %or whatever formatting your file is
	fclose(fvv);

	
	% Get number of time intervals
	numvvhours = length(raw_vv{1}(:));

	%% Load datenum info array col 1
	for vvhours=1:numvvhours
	    raw_vv{1}(vvhours) = datenum(raw_vv{3}(vvhours),formatIn3);
	end


	%% LOAD data from vagverket
	disp('Load data from vagverket...')
	lowestIndex = 2;
	for mins=1:nummins
	    
	    % Progress output
	    if mod(mins,40) == 0
	        fprintf('%.2f %% done\n',mins/nummins*100);
	    end
	    
	    % Set an offset, used to build datasets for the forecast models
	    current_offset = addtodate(newdataset(mins,1), -offset_time, 'minute');
	    
	    for vvhours=lowestIndex:numvvhours-1

	        % Optimize the search algorithm
	        if current_offset < raw_vv{1}(vvhours)
	            break
	        end
	        if raw_vv{1}(vvhours) < current_offset
	            lowestIndex = vvhours;
	        end
	        
	        % Find matching measurement
	        if current_offset >= raw_vv{1}(vvhours) &&...
	           current_offset < raw_vv{1}(vvhours+1)
	       
	            % Add Road heat
	            newdataset(mins,indTempRoadVV) = raw_vv{4}(vvhours);
	            % Add Air temperature
	            newdataset(mins,indTempVV) = raw_vv{5}(vvhours);
	            % Add Air Humidity
	            newdataset(mins,indHumidityVV) = raw_vv{6}(vvhours);
	            % Add Daggpunktstemperatur
	            newdataset(mins,indDewVV) = raw_vv{7}(vvhours);
	            
	            % Add Regn & Snow
	            if raw_vv{8}(vvhours) == 1
	                newdataset(mins,indRainVV) = 0;
	                newdataset(mins,indSnowVV) = 0;
	            elseif raw_vv{8}(vvhours) == 2 || ...
	                    raw_vv{8}(vvhours) == 3
	                newdataset(mins,indRainVV) = raw_vv{9}(vvhours);
	                newdataset(mins,indSnowVV) = 0;
	            elseif raw_vv{8}(vvhours) == 4
	                newdataset(mins,indRainVV) = 0;
	                newdataset(mins,indSnowVV) = raw_vv{9}(vvhours);
	            elseif raw_vv{8}(vvhours) == 6
	                newdataset(mins,indRainVV) = raw_vv{9}(vvhours);
	                newdataset(mins,indSnowVV) = raw_vv{9}(vvhours);
	            else
	                newdataset(mins,indRainVV) = 0;
	                newdataset(mins,indSnowVV) = 0;
	            end

	            % Add Wind
	            newdataset(mins,indWindVV) = raw_vv{13}(vvhours);
	        end
	    end
	end


	%% Clear data from vägverket
	% Limit temperature
	newdataset(newdataset(:,indTempRoadVV) < -30,indTempRoadVV) = mean(newdataset(:,indTempRoadVV));
	% Limit humidity
	newdataset(newdataset(:,indHumidityVV) < -30,indHumidityVV) = mean(newdataset(:,indHumidityVV));
	% Cap Rain and Snow lvl at zero
	newdataset(newdataset(:,indRainVV) < 0,indRainVV) = 0;
	newdataset(newdataset(:,indSnowVV) < 0,indSnowVV) = 0;


	%% Get previous measurements from...
	% Road heat
	% Airtemp
	% Humidity
	% Dew point temperature
	% Rain
	% Snow
	% Wind speed
	% Wiperspeed
	counter = 15;
	while counter < 53
	    newdataset(:,counter) = [zeros(step_behind*1,1);newdataset(1:end-step_behind*1,counter-1)];
	    counter = counter + 1;
	    newdataset(:,counter) = [zeros(step_behind*2,1);newdataset(1:end-step_behind*2,counter-2)];
	    counter = counter + 1;
	    newdataset(:,counter) = [zeros(step_behind*3,1);newdataset(1:end-step_behind*3,counter-3)];
	    counter = counter + 1;
	    newdataset(:,counter) = [zeros(step_behind*4,1);newdataset(1:end-step_behind*4,counter-4)];
	    counter = counter + 2;
	end
end