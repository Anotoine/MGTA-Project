clearvars; close all;
load('..\DataArrivals.mat')

Hstart = [11 0];
Hend = [13 0];
HNoReg = [15 3];
PAAR = 20;
AAR = 60;
radius = 1500;
SlotsGDP = computeSlotsGDP (Hstart, Hend, HNoReg, PAAR, AAR);

i = 1;
HFileH = 7;
HFileM = 0;
HFilei = [HFileH HFileM];

while HFileH <= Hstart(1)
    if(HFilei(i,2) >= 59)
        HFileH = HFileH + 1;
        HFileM = 0;
    else
        HFileM = HFileM + 1;
    end
    HFilei = [HFilei; [HFileH HFileM]];
    i = i + 1;
end
    
i = 1;
while i <= length(HFilei)

    %For the Hfile variation
    [~, ~, ~, ~, ExcludedF(:,i), ControlledF(:,i)] = computerAircraftStatus (DataA.ETA, DataA.ETD, DataA.Distance, DataA.Int, HFilei(i,:), Hstart, HNoReg, radius);

    [~, GroundDelayF(:,:,i), AirDelayF(:,:,i)] = assignSlots (SlotsGDP, DataA.ETA, ControlledF(:,i), ExcludedF(:,i));
    
    %->AirDelay
    AmountF(i,1,1) = length(find(AirDelayF(:,1,i) > 0));
    MaxF(i,1,1) = max(AirDelayF(:,2,i));
    TotalF(i,1,1) = sum(AirDelayF(:,2,i));
    AvF(i,1,1) = sum(AirDelayF(:,2,i))/494;
    
    %->GroundDelay
    AmountF(i,2,1) = length(find(GroundDelayF(:,1,i) > 0));
    MaxF(i,2,1) = max(GroundDelayF(:,2,i));
    TotalF(i,2,1) = sum(GroundDelayF(:,2,i));
    AvF(i,2,1) = sum(GroundDelayF(:,2,i))/AmountF(i,2,1);
    
    i = i + 1;
end
 
yfile = 0:6500;
xfile = 11*ones(1,length(yfile));

figure('name','Delay - HFile')
suptitle('Air and Ground Delay vs File time');

subplot(2,2,1)
hold on;
title('Amount of planes affected');
xlabel('File time (h)'); ylabel('Amount of planes (# Aircrafts)');
plot(HFilei(:,1)+HFilei(:,2)/60,AmountF(:,1,1),HFilei(:,1)+HFilei(:,2)/60,AmountF(:,2,1));
plot(xfile(1:600),yfile(1:600),'k--')
plot(7:12,494*ones(1,12-7+1),':r')
legend('Air Delay','Ground Delay','GDP Start (11h)','Total # of aircrafts','location','southwest')

subplot(2,2,2)
hold on;
title('Maximum Delay');
xlabel('File time (h)'); ylabel('Maximum delay (min)');
plot(HFilei(:,1)+HFilei(:,2)/60,MaxF(:,1,1),HFilei(:,1)+HFilei(:,2)/60,MaxF(:,2,1));
plot(xfile(1:150),yfile(1:150),'k--')
legend('Air Delay','Ground Delay','GDP Start (11h)','location','southwest')

subplot(2,2,3)
plot(HFilei(:,1)+HFilei(:,2)/60,TotalF(:,1,1),HFilei(:,1)+HFilei(:,2)/60,TotalF(:,2,1));
hold on;
plot(xfile,yfile,'k--')
text(10.81222,3790.5,'Crossing point at 10:50 AM \rightarrow ', 'HorizontalAlignment', 'right');    
legend('Air Delay','Ground Delay','GDP Start (11h)','location','southwest')
title('Total Delay');
xlabel('File time (h)'); ylabel('Amount of total delay (min)'); axis([7 12 500 6500])

subplot(2,2,4)
hold on;
title('Average Delay');
xlabel('File time (h)'); ylabel('Average delay (min)');
plot(HFilei(:,1)+HFilei(:,2)/60,AvF(:,1,1),HFilei(:,1)+HFilei(:,2)/60,AvF(:,2,1));
plot(xfile(1:60),yfile(1:60),'k--')
legend('Air Delay','Ground Delay','GDP Start (11h)','location','southwest')
