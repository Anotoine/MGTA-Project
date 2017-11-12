function [] = plotAC(arrPerSlot, depPerSlot, arrMax, depMax, arrX, depX)

	x = [arrMax, arrMax, 0];
	y = [0, depMax, depMax];
    
    y1 = [depMax, depMax, 6, 0];
    x1 = [0, 16, arrMax, arrMax];

    figure();
	line(x, y, 'Color','blue','LineStyle','--');
    line(x1, y1, 'Color','green','LineStyle','-')
	hold on;
	scatter(arrPerSlot, depPerSlot, 'bo');
    scatter(arrX',depX','go')
	title('Airport Arrival/Departure capacity curve');xlabel('Arrival/15 min');ylabel('Departures/15 min');
	
	axisMaxVal = max([max(arrPerSlot)+1, max(depPerSlot)+1]);
	
	xlim([0, axisMaxVal]);ylim([0, axisMaxVal]);
	
end