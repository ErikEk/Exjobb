function SaveData(variablename,loop)
    global cleareddataset
	%% Save cleareddataset as .csv and .mat
	csvwrite([variablename num2str(loop) '.csv'],cleareddataset)
	save([variablename num2str(loop) '.mat'])
end