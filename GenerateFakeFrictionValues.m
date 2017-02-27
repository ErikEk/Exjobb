function GenerateFakeFrictionValues(variablename)

    global nummins starttime formatIn formatIn2 formatIn3 inc_min_step offset_time current current_end min_quality 
    global search_region max_search_time prev_time alldataset dataset newdataset step_behind
    global indFrictionValue indFrictionQuality ind1PrevDistFriction ind1PrevTimeFriction ind1PrevFrictionValue ind1PrevFrictionQuality
    global indTempSMHI indTempRoadVV indTempVV indHumidityVV indDewVV indRainVV indSnowVV indWindVV indWiperSpeedCar indLog
    global indLat indMappedLog indMappedLat ind2PrevDistFriction ind2PrevTimeFriction ind2PrevFrictionValue ind3PrevDistFriction
    global ind3PrevTimeFriction ind3PrevFrictionValue indTempCar
    
    
    %% Generate fake friction values
    disp('Generate fake friction values')
    mintemp = min(newdataset(:,indTempRoadVV));
    maxtemp = max(newdataset(:,indTempRoadVV));
    minhumidity = min(newdataset(:,indHumidityVV));
    maxhumidity = max(newdataset(:,indHumidityVV));

    difftemp = abs(maxtemp-mintemp)
    diffhumidity = abs(maxhumidity-minhumidity)

    sizedataset = size(newdataset,1);
    index = 1;
    for mins=1:nummins
        % Progress output
        if mod(mins,100) == 0
            fprintf('%.2f %% done\n',mins/nummins*100);
        end
        influence_temp = ((-(newdataset(mins,indTempRoadVV)-mintemp)/difftemp)+1);
        influence_humidity = ((-(newdataset(mins,indHumidityVV)-minhumidity)/diffhumidity)+1);

        newdataset(mins,indFrictionValue) = ((rand()*0.8-0)+...
            influence_temp+influence_humidity)/3;

        % Fetch data from 0.5, 1, 1.5 hours ago
        if mins<=30
            index = 1;
        else
            index = mins-30/inc_min_step;
        end
        influence_temp = ((-(newdataset(index,indTempRoadVV)-mintemp)/difftemp)+1);
        influence_humidity = ((-(newdataset(index,indHumidityVV)-minhumidity)/diffhumidity)+1);
        
        newdataset(mins,ind1PrevFrictionValue) = ((rand()*0.8-0)+...
            influence_temp+influence_humidity)/3;
        newdataset(mins,ind1PrevFrictionQuality) = 5;
        newdataset(mins,ind1PrevDistFriction) = 0.005;
        newdataset(mins,ind1PrevTimeFriction) = 30;

        if mins<=60
            index = 1;
        else
            index = mins-60/inc_min_step;
        end
        influence_temp = ((-(newdataset(index,indTempRoadVV)-mintemp)/difftemp)+1);
        influence_humidity = ((-(newdataset(index,indHumidityVV)-minhumidity)/diffhumidity)+1);
        newdataset(mins,ind2PrevFrictionValue) = ((rand()*0.8-0)+...
            influence_temp+influence_humidity)/3;
        newdataset(mins,ind2PrevDistFriction) = 0.01;
        newdataset(mins,ind2PrevTimeFriction) = 60;

        if mins<=90
            index = 1;
        else
            index = mins-90/inc_min_step;
        end
        influence_temp = ((-(newdataset(index,indTempRoadVV)-mintemp)/difftemp)+1);
        influence_humidity = ((-(newdataset(index,indHumidityVV)-minhumidity)/diffhumidity)+1);
        newdataset(mins,ind3PrevFrictionValue) = ((rand()*0.8-0)+...
            influence_temp+influence_humidity)/3;
        newdataset(mins,ind3PrevDistFriction) = 0.02;
        newdataset(mins,ind3PrevTimeFriction) = 90;
        
        % Remove some of the samples
        if randi([0,30]) ~= 0
            newdataset(mins,indFrictionValue) = 0;
        end
    end
end