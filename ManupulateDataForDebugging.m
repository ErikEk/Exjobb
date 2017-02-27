function ManipulateDataForDebugging()

    global newdataset alldataset indFrictionValue
	%% Prep data for plotting (not used, for debugging)
	removelowerpointsnot = 0;
	tempnewdataset = newdataset;
	tempalldataset = alldataset;
	newdataset(newdataset(:,indFrictionValue)==0,indFrictionValue) = -10;
	alldataset(alldataset(:,indFrictionValue)==0,indFrictionValue) = -10;

	if removelowerpointsnot == 1
	    newdataset = tempnewdataset;
	    alldataset = tempalldataset;
	end



	%%---------------------------------------
	% For report (not used)
	%----------------------------------------
	% Plot friction and temp (for report and debugging)
	%%%%%%%%%%hold on

	%plot(newdataset(:,1),newdataset(:,indFrictionValue),'*r','markersize',10)
	%plot(newdataset(:,1),alldataset(:,indFrictionValue),'omagenta')
	%%%%%%%%%%%%plot(newdataset(:,1),newdataset(:,ind1PrevFrictionValue),'ored')

	% Plot temp from VV
	% s = normc(newdataset(:,19))
	% norms = s - min(s(:))
	% norms = norms ./ max(norms(:))
	%plot(newdataset(:,1),norms,'--g')

	% Plot temp from SMHI
	% s = normc(newdataset(:,9))
	% norms = s - min(s(:))
	% norms = norms ./ max(norms(:))
	%plot(newdataset(:,1),norms,'--y')

	% Plot humidity
	%%%%%%s = normc(newdataset(:,24));
	%%%%%%norms = s - min(s(:));
	%%%%%%norms = norms ./ max(norms(:));
	%%%%%%%%plot(newdataset(:,1),norms,'--black')

	% Plot regn
	%%%%%%%%%%%plot(newdataset(:,1),newdataset(:,indRainVV),'-b')
	%%%%%%datetick('x','yyyy-mm-dd','keepticks')

	% Plot snow
	%%%%%%%%%%5plot(newdataset(:,1),newdataset(:,indSnowVV),'color','[0.3 0.3 1.0]')
	%datetick('x','yyyy-mm-dd','keepticks')
	%set(gca, 'XTick', newdataset(:,1:6:end));
	%%%%%%%%%%%tickDates = newdataset(1,1):1:newdataset(end,1); %// creates a vector of tick positions
	%%%%%%%%%%%%set(gca, 'XTick' , tickDates , 'XTickLabel' , datestr(tickDates,'yyyy-mm-dd') )
	%xticklabel_rotate;
	% NumTicks = 300;
	% L = get(gca,'XLim');
	% set(gca,'XTick',linspace(L(1),L(2),NumTicks))
	% set(gca,'XMinorTick','on','YMinorTick','on')
	% Plot wiperspeed
	%plot(newdataset(:,1),newdataset(:,49),'-c')
	%%%%%%hold off
	%legend('Friction values (Segment)','Friciton values (Region)','SMHI Temperature','VV Temperature,','Humidity','Rainfall')
	%%%%%%legend('Friction values','Humidity,','Rain')



	%% Plot temperatures (for report)
	%%%%%%%%hold off

	% Plot temp from VV
	%%%%%%%%%%%%%%plot(newdataset(:,1),newdataset(:,19),'-g')
	%%%%%%%%hold on

	% Plot temp from SMHI
	%%%%%%%%%plot(newdataset(:,1),newdataset(:,9),'-b')


	% Plot temp from car data
	%%%%%%%%%newdataset(newdataset(:,indTempCar) == 0,indTempCar) = -100;
	%%%%%%%%%%%%%plot(newdataset(:,1),newdataset(:,indTempCar),'or')
	%%%%%%%%ylabel('Temperature')
	%%%%%%%%legend('Vägverket','SMHI','From vehicles in the region')
	%%%%%%%%datetick('x','yyyy-mm-dd','keepticks')
	%xticklabel_rotate;
	%%%%%%%%%%%%%%%tickDates = newdataset(1,1):1:newdataset(end,1); %// creates a vector of tick positions
	%%%%%%%%%%%%%set(gca, 'XTick' , tickDates , 'XTickLabel' , datestr(tickDates,'yyyy-mm-dd') );



end