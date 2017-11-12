clearvars; close all;
load('..\DataArrivals.mat')

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
    
    %->AirDelay
    AmountR(i,1,1) = length(find(AirDelayR(:,1,i) > 0));
    MaxR(i,1,1) = max(AirDelayR(:,2,i));
    TotalR(i,1,1) = sum(AirDelayR(:,2,i));
    AvR(i,1,1) = sum(AirDelayR(:,2,i))/494;
    
    %->GroundDelay
    AmountR(i,2,1) = length(find(GroundDelayR(:,1,i) > 0));
    MaxR(i,2,1) = max(GroundDelayR(:,2,i));
    TotalR(i,2,1) = sum(GroundDelayR(:,2,i));
    AvR(i,2,1) = sum(GroundDelayR(:,2,i))/AmountR(i,2,1);
end

figure('name','Delay - Radius')
suptitle('Air and Ground Delay vs File time');

subplot(2,2,1)
hold on;
title('Amount of planes affected');
xlabel('Radius (NM)'); ylabel('Amount of planes (# Aircrafts)');
plot(radiusi,AmountR(:,1,1),radiusi,AmountR(:,2,1));
plot(radiusi,494*ones(1,length(radiusi)),':r')
legend('Air Delay','Ground Delay','Total # of aircrafts','location','northeast')


subplot(2,2,2)
hold on;
title('Maximum Delay');
xlabel('Radius (NM)'); ylabel('Maximum delay (min)');
plot(radiusi,MaxR(:,1,1),radiusi,MaxR(:,2,1));
legend('Air Delay','Ground Delay','location','northeast')

subplot(2,2,3)
plot(radiusi,TotalR(:,1,1),radiusi,TotalR(:,2,1));
hold on;
text(319.65,3790.5,'\leftarrow Crossing point at 320 NM ');   
legend('Air Delay','Ground Delay','location','northeast')
title('Total Delay');
xlabel('Radius (NM)'); ylabel('Amount of total delay (min)');

subplot(2,2,4)
hold on;
title('Average Delay');
plot(radiusi,AvR(:,1,1),radiusi,AvR(:,2,1));
xlabel('Radius (NM)'); ylabel('Amount of average delay (min)');
legend('Air Delay','Ground Delay','location','northeast')




figure('name','Delay - Radius2')
plot(radiusi,TotalR(:,1,1),radiusi,TotalR(:,2,1));
text(319.65,3790.5,'\leftarrow Crossing point at 320 NM ');   
legend('Air Delay','Ground Delay','location','southeast')
title('Air and Ground Delay vs Radius of regulation');
xlabel('Radius (NM)'); ylabel('Amount of total delay (min)');
