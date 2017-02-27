function ClearDataSet()
    global newdataset starttime endtime indFrictionValue ind1PrevFrictionValue formatIn cleareddataset
    
	%% Remove datapoint if there is no friction value
	% Copy newdataset
	cleareddataset = newdataset;

	% Get serial date number from start and end date
	%current = datenum(starttime,formatIn);
	%lasttime = datenum(endtime,formatIn);

	disp('remove datapoints without friction value...')
	cleareddataset((cleareddataset(:,indFrictionValue) == 0),:) = [];
	cleareddataset((cleareddataset(:,ind1PrevFrictionValue) == 0),:) = [];
end

