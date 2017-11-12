clearvars; close all;
load('DataArrivals.mat')

HFile = [9 0];
Hstart = [11 0];
Hend = [13 0];
HNoReg = [15 3];
PAAR = 20;
AAR = 60;
radius = 1500;
SlotsGDP = computeSlotsGDP (Hstart, Hend, HNoReg, PAAR, AAR);

radiusi = 1:5000;

for i = 1:5000
    %For the Radius variation
    [~, ~, ~, ~, ExcludedR(:,i), ControlledR(:,i)] = computerAircraftStatus (DataA.ETA, DataA.ETD, DataA.Distance, DataA.Int, HFile, Hstart, HNoReg, radiusi(i));

    [~, GroundDelayR(:,:,i), AirDelayR(:,:,i)] = assignSlots (SlotsGDP, DataA.ETA, ControlledR(:,i), ExcludedR(:,i));
end

TotalAirDelayR(:) = sum(AirDelayR(:,2,:));
TotalGroundDelayR(:) = sum(GroundDelayR(:,2,:));

figure('name','Delay - Radius')
plot(radiusi,TotalAirDelayR,radiusi,TotalGroundDelayR);
text(319.65,3790.5,'\leftarrow Crossing point at 320 NM ');   
legend('Air Delay','Ground Delay','location','southeast')
title('Air and Ground Delay vs Radius of regulation');
xlabel('Radius (NM)'); ylabel('Amount of total delay (min)');


i = 1;
HFileH = 7;
HFileM = 0;
HFilei = [HFileH HFileM];

while HFileH <= 11
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
    
    i = i + 1;
end

TotalAirDelayF(:) = sum(AirDelayF(:,2,:));
TotalGroundDelayF(:) = sum(GroundDelayF(:,2,:));
y = 1:6500;
x = 11*ones(1,length(y));

figure('name','Delay - HFile')
plot(HFilei(:,1)+HFilei(:,2)/60,TotalAirDelayF,HFilei(:,1)+HFilei(:,2)/60,TotalGroundDelayF);
hold on;
plot(x,y,'k--')
text(10.81222,3790.5,'Crossing point at 10:50 AM \rightarrow ', 'HorizontalAlignment', 'right');    
legend('Air Delay','Ground Delay','GDP Start (11h)','location','southwest')
title('Air and Ground Delay vs File time');
xlabel('File time (h)'); ylabel('Amount of total delay (min)'); axis([7 12 500 6500])
