function [] = plotACPoligon(arrPerSlot, depPerSlot, arrMax, depMax, arrX, depX, alpha)
    
	%The points for the Capacity lines
    y = [depMax, depMax, 6, 0];
    x = [0, 11, arrMax, arrMax];

    figure('name','AC Poligon');
    line(x, y, 'Color','green','LineStyle','-')
	hold on;
	scatter(arrPerSlot, depPerSlot, 'bo', 'fill'); %Demand
    scatter(arrX',depX','ro') %Capacity applied
    tit = ['Airport Arrival/Departure capacity curve (\alpha = ' num2str(alpha) ')'];
	title(tit);xlabel('Arrival/15 min');ylabel('Departures/15 min');
    legend('Maximum Capacity','Before AC','After AC')
	
	axisMaxVal = max([max(arrPerSlot)+1, max(depPerSlot)+1]);
	
	xlim([0, axisMaxVal]);ylim([0, axisMaxVal]);
	
end