function LoadCarData(filename)
    global nummins starttime formatIn formatIn2 formatIn3 inc_min_step offset_time current current_end min_quality 
    global search_region max_search_time prev_time alldataset dataset newdataset
    global indFrictionValue indFrictionQuality ind1PrevDistFriction ind1PrevTimeFriction ind1PrevFrictionValue ind1PrevFrictionQuality
    global indTempSMHI indTempRoadVV indTempVV indHumidityVV indDewVV indRainVV indSnowVV indWindVV indWiperSpeedCar indLog
    global indLat indMappedLog indMappedLat ind2PrevDistFriction ind2PrevTimeFriction ind2PrevFrictionValue ind3PrevDistFriction
    global ind3PrevTimeFriction ind3PrevFrictionValue indTempCar

    % Allocate some space
    alldataset = zeros(fix(nummins),50);

	fid = fopen(filename, 'rt');
	raw = textscan(fid, ['%s %s %s',repmat('%f',[1,10])],'Delimiter',',','headerLines', 0);
	fclose(fid);



	%% Fix the temperature from car data (not used)
	% Fill in the gaps in the dataset. 
	lastTemp = mean(raw{7}(~isnan(raw{7}(:))));
	for i=1:length(raw{7}(:))
	    if ~isnan(raw{7}(i))
	        lastTemp = raw{7}(i);
	    end
	    raw{7}(i) = lastTemp;
	end


	%% Fix wiperspeed values (not used)
	% Fill in the gaps in the dataset. 
	lastTemp = 0;
	for i = 1:length(raw{8})
	    if(~isnan(raw{8}(i)))
	        lastTemp = raw{8}(i);
	   end
	   raw{8}(i) = lastTemp;
	end



	%% Load friction values from car data...
	disp('Load friction values from car data...')
	% Allocate some space for the dataset
	dataset = zeros(fix(nummins),64);
	% Get start date
	current = datenum(starttime,formatIn);
	% Dummy variable to optimize the search algorithm
	lowestIndex=1;
	% Loop through every time interval
	for mins=1:nummins
	    
	    % Progress output
	    if mod(mins,1000) == 0
	        fprintf('%f %% done\n',mins/nummins*100);
	    end
	    current_end = addtodate(current, inc_min_step, 'minute');
	    
	    % Set an offset, used to build datasets for the forecast models
	    current_offset = addtodate(current, -offset_time, 'minute');
	    current_end_offset = addtodate(current_end, -offset_time, 'minute');
	    
	    % Dummy variables used to calculate the average
	    numfriction = 0;
	    numwiperspeedvalues = 0;
	    numtempvalues=0;
	    
	    for m=lowestIndex:length(raw{3}(:))
	        
	        % Find matching measurement
	        if (datenum(raw{3}(m),formatIn) >= current) && ...
	           (datenum(raw{3}(m),formatIn) < current_end) && ...
	           ~isnan(raw{5}(m)) && ...
	           (raw{6}(m) >= min_quality)
	       
	           % Save index to dataset
	           dataset(mins,2) = m;
	           
	           % Store friction value and quality value
	           dataset(mins,indFrictionValue) = dataset(mins,indFrictionValue)+raw{5}(m);
	           dataset(mins,indFrictionQuality) = dataset(mins,indFrictionQuality)+raw{6}(m);
	           
	           % Save log/lat and mapped log/lat
	           dataset(mins,indLog) = raw{9}(m);
	           dataset(mins,indLat) = raw{10}(m);
	           dataset(mins,indMappedLog) = raw{11}(m);
	           dataset(mins,indMappedLat) = raw{12}(m);

	           
	           numfriction = numfriction + 1;
	        end
	        
	        % Looking for wiperspeed value
	        if (datenum(raw{3}(m),formatIn) >= current_offset) && ...
	           (datenum(raw{3}(m),formatIn) < current_end_offset)
	           dataset(mins,indWiperSpeedCar) = dataset(mins,indWiperSpeedCar)+raw{8}(m);
	           numwiperspeedvalues = numwiperspeedvalues + 1;
	        end
	        
	        % Look for temperature values
	        if (datenum(raw{3}(m),formatIn) >= current_offset) && ...
	           (datenum(raw{3}(m),formatIn) < current_end_offset)
	            dataset(mins,indTempCar) = dataset(mins,indTempCar)+raw{7}(m);
	            numtempvalues = numtempvalues + 1;
	        end
	        
	        % Optimize the search algorithm
	        if datenum(raw{3}(m),formatIn) < current_offset
	            lowestIndex = m;
	        end
	        if datenum(raw{3}(m),formatIn) > current_end
	            dataset(mins,2) = m;
	            break
	        end
	    end
	    
	    if dataset(mins,indFrictionValue) ~= 0 % Set mean of friction value
	        dataset(mins,indFrictionValue) = dataset(mins,indFrictionValue)/numfriction;
	        dataset(mins,indFrictionQuality) = dataset(mins,indFrictionQuality)/numfriction;
	    end
	    
	    if dataset(mins,indWiperSpeedCar) ~= 0 % Set mean of wiper speed
	        dataset(mins,indWiperSpeedCar) = dataset(mins,indWiperSpeedCar)/numwiperspeedvalues;
	    end
	    if dataset(mins,indTempCar) ~= 0 % Set mean of temperature
	        dataset(mins,indTempCar) = dataset(mins,indTempCar)/numtempvalues;
	    end
	    
	    % Store the current time
	    dataset(mins,1) = current;
	    
	    % Save time stamp
	    [~,~,~,dataset(mins,8),~,~] = datevec(datestr(current),formatIn2);
	    
	    % Update the time
	    current = current_end;
	end

	hold off

	% Copy dataset into newdataset
	newdataset = dataset;
    size(newdataset)
    size(dataset)

	%% Find the middle of the road segment (Not used)
	middleLog = mean(dataset((dataset(:,indMappedLog) > 0),indMappedLog));
	middleLat = mean(dataset((dataset(:,indMappedLat) > 0),indMappedLat));


	%% LOAD data from all friction values
	fid = fopen('GetAllFrictionValues.csv', 'rt'); %Query5_onlyfriction.csv
	raw_all = textscan(fid, ['%s %s %s',repmat('%f',[1,10])],'Delimiter',',','headerLines', 0);
	fclose(fid);

	% Allocate some space
	alldataset = zeros(fix(nummins),50);

	disp('Load friction values from all friction values...')
	current = datenum(starttime,formatIn);

	% Dummy optimizer variable
	lowestIndex=1;

	% Loop through all time intervals
	for mins=1:nummins
	    
	    % Progress output
	    if mod(mins,40) == 0
	        fprintf('%f %% done\n',mins/nummins*100);
	    end
	    current_end = addtodate(current, inc_min_step, 'minute');
	    
	    % Set an offset, used to build datasets for the forecast models
	    current_offset = addtodate(current, -offset_time, 'minute');
	    current_end_offset = addtodate(current_end, -offset_time, 'minute');
	    
	    numfriction = 0;
	    
	    % Loop through all friction measurements
	    for m=lowestIndex:length(raw_all{3}(:))
	        
	        % Find matching measurement
	        if (datenum(raw_all{3}(m),formatIn) >= current_offset) && ...
	           (datenum(raw_all{3}(m),formatIn) < current_end_offset) && ...
	           (raw_all{6}(m) >= min_quality)
	       
	           alldataset(mins,indFrictionValue) = alldataset(mins,indFrictionValue)+raw_all{5}(m);
	           alldataset(mins,indFrictionQuality) = alldataset(mins,indFrictionQuality)+raw_all{6}(m);
	           
	           alldataset(mins,49) = raw_all{9}(m);
	           alldataset(mins,50) = raw_all{10}(m);
	           
	           numfriction = numfriction + 1;
	        end
	        
	        % Optimize the search algorithm
	        if datenum(raw_all{3}(m),formatIn) < current_offset
	            lowestIndex = m;
	        end
	        if datenum(raw_all{3}(m),formatIn) > current_end_offset
	            break
	        end
	    end
	    
	    if alldataset(mins,indFrictionValue) ~= 0 % Set mean friction value and quality
	        alldataset(mins,indFrictionValue) = alldataset(mins,indFrictionValue)/numfriction;
	        alldataset(mins,indFrictionQuality) = alldataset(mins,indFrictionQuality)/numfriction;
	    end
	    
	    % Save the current time
	    alldataset(mins,1) = current;

	    % Update the time mark
	    current = current_end;
	end

	%%  FIND LAST GLOBAL FRICTIONVALUE (TEST CASE)
	disp('Look for global friction values')

	% Loop through all time intervals
	for mins=1:nummins
	    
	    % Progress output
	    if mod(mins,40) == 0
	        fprintf('%f %% done\n',mins/nummins*100);
	    end
	    
	    found_frictionvalue = false;
	    
	    for searchhour = mins-1:-1:2
	        
	        if (mins-searchhour)*inc_min_step > 5*60
	            break;
	        end
	        
	        % Find matching measurement
	        if (alldataset(searchhour,indFrictionValue) ~= 0) && ...
	           (sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	           (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2) < search_region) && ...
	           ((mins-searchhour)*inc_min_step < max_search_time*60) && ... % Max 5 hours
	           (alldataset(searchhour,indFrictionQuality) >= min_quality) % Qulity needs to be better or equal to min_quality
	       
	            newdataset(mins,ind1PrevFrictionValue) = alldataset(searchhour,indFrictionValue);
	            newdataset(mins,ind1PrevFrictionQuality) = alldataset(searchhour,indFrictionQuality);
	            newdataset(mins,ind1PrevTimeFriction) = mins-searchhour;
	            if alldataset(searchhour,49) + alldataset(searchhour,50) > 0
	                newdataset(mins,ind1PrevDistFriction) = sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	                    (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2);
	            else
	                newdataset(mins,ind1PrevDistFriction) = 0;
	            end
	            found_frictionvalue = true;
	            break;
	        end
	    end
	    if found_frictionvalue == false
	        newdataset(mins,ind1PrevDistFriction) = 0;
	        newdataset(mins,ind1PrevTimeFriction) = 0;
	        newdataset(mins,ind1PrevFrictionValue) = 0;
	    end
	    
	    
	    found_frictionvalue = false;
	    for searchhour = searchhour-1:-1:2
	        if (alldataset(searchhour,indFrictionValue) ~= 0) && ...
	            (sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	           (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2) < search_region) && ...
	           ((mins-searchhour)*inc_min_step < max_search_time*60) && ... % Max 5 hours
	           (alldataset(searchhour,indFrictionQuality) >= min_quality) % Qulity needs to be better or equal to min_quality
	            
	            newdataset(mins,ind2PrevFrictionValue) = alldataset(searchhour,indFrictionValue);
	            newdataset(mins,ind2PrevTimeFriction) = mins-searchhour;
	            if alldataset(searchhour,49) + alldataset(searchhour,50) > 0
	                newdataset(mins,ind2PrevDistFriction) = sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	                    (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2);
	            else
	                newdataset(mins,ind2PrevDistFriction) = 0;
	            end
	            found_frictionvalue = true;
	            break;
	        end
	    end
	    

	    
	    if found_frictionvalue == false
	        newdataset(mins,ind2PrevDistFriction) = 0;
	        newdataset(mins,ind2PrevTimeFriction) = 2;
	        newdataset(mins,ind2PrevFrictionValue) = 0.5;
	    end
	    
	    
	    found_frictionvalue = false;
	    for searchhour = searchhour-1:-1:2
	        if (alldataset(searchhour,indFrictionValue) ~= 0) && ...
	            (sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	           (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2) < search_region) && ...
	           ((mins-searchhour)*inc_min_step < max_search_time*60) && ... % Max 5 hours
	           (alldataset(searchhour,indFrictionQuality) >= min_quality) % Qulity needs to be better or equal to min_quality
	       
	            newdataset(mins,ind3PrevFrictionValue) = alldataset(searchhour,indFrictionValue);
	            newdataset(mins,ind3PrevTimeFriction) = mins-searchhour;
	            if alldataset(searchhour,49) + alldataset(searchhour,50) > 0
	                newdataset(mins,ind3PrevDistFriction) = sqrt((newdataset(mins,indMappedLog)-alldataset(searchhour,49))^2+...
	                    (newdataset(mins,indMappedLat)-alldataset(searchhour,50))^2);
	            else
	                newdataset(mins,ind3PrevDistFriction) = 0;
	            end
	            found_frictionvalue = true;
	            break;
	        end
	    end
	    
	    if found_frictionvalue == false
	        newdataset(mins,ind3PrevDistFriction) = 0;
	        newdataset(mins,ind3PrevTimeFriction) = 2;
	        newdataset(mins,ind3PrevFrictionValue) = 0.5;
	    end
	end

	% Clear every friction value when distance is further then 10 (not used)
	%newdataset(newdataset(:,ind1PrevDistFriction) > 10,ind1PrevDistFriction) = 0;
	%newdataset(newdataset(:,ind2PrevDistFriction) > 10,ind2PrevDistFriction) = 0;
	%newdataset(newdataset(:,ind3PrevDistFriction) > 10,ind3PrevDistFriction) = 0;
	% Clear every friction value from 5 hours ago
	%newdataset(newdataset(:,ind1PrevTimeFriction) > 300,ind1PrevTimeFriction) = 0;
	%newdataset(newdataset(:,ind2PrevTimeFriction) > 300,ind2PrevTimeFriction) = 0;
	%newdataset(newdataset(:,ind3PrevTimeFriction) > 300,ind3PrevTimeFriction) = 0;


end