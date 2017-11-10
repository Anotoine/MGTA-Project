function [] = plotAC(arrPerSlot, depPerSlot, arrMax, depMax)

	x = [0, arrMax, arrMax, 0, 0];
	y = [0, 0, depMax, depMax, 0];

	plot(x, y, 'b-');
	hold on;
	plot(arrPerSlot, depPerSlot, 'ro');
	title('Airport Arrival/Departure capacity curve');xlabel('Arrival/15 min');ylabel('Departures/15 min');
	xlim([0, max(arrPerSlot)+1]);ylim([0, max(depPerSlot)+1]);
	
end