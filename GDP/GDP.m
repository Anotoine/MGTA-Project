%Test GDP --> Main
clearvars;
load('..\DataArrivals.mat')
HFile = [10 0]; %0900
Hstart = [11 0];
Hend = [13 0];

PAAR = 20;
AAR = 60;
Slot = 3;
radius = 500; %1500
close all;

% [SlotsRBS, DelayRBS] = RBS (Name, ETA, Hstart, Hend, slot)
[SlotsRBS, DelayDayRBS, DelayAffectedRBS] = RBS (DataA.Number, DataA.ETA, Hstart, Hend, Slot);

% [HNoReg, delay] = aggregateDemand (ETA, Hstart, Hend, PAAR, AAR);
[HNoReg, delayGDP] = aggregateDemand (DataA.ETA, Hstart, Hend, PAAR, AAR);

%[Slots] = computeSlotsGDP (HStart, Hend, HNoReg, PAAR, AAR);
SlotsGDP = computeSlotsGDP (Hstart, Hend, HNoReg, PAAR, AAR);

% [NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled] =...
%  computerAircraftStatus (ETA, ETD, Distances, International, HFile, Hstart, HNoReg, radius)
[NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled] =...
    computerAircraftStatus (DataA.ETA, DataA.ETD, DataA.Distance, DataA.Int, HFile, Hstart, HNoReg, radius);

% [slots, GroundDelay, AirDelay] = assignSlots (slots, ETA, Controlled, Excluded)
[SlotsGDP, GroundDelay, AirDelay] = assignSlots (SlotsGDP, DataA.ETA, Controlled, Excluded);

% CTA = computeCTA (ETA, GroundDelay, AirDelay)
CTA = computeCTA (DataA.ETA, GroundDelay, AirDelay);

% plotHistograms (ETA, CTA, AAR, PAAR)
plotHistograms(DataA.ETA, CTA, AAR, PAAR);

%Computing the tables
    %-> For the RBS
TableSlotsRBS = table(DataA.Number,DataA.ETA,zeros(length(DataA.ETA),2),zeros(length(DataA.ETA),1),'VariableNames',{'ID','ETA','CTA','Delay'});
j = 1;
for i = 1:length(TableSlotsRBS{:,1})
    pos = find(TableSlotsRBS{i,1} == SlotsRBS(:,3));
    TableSlotsRBS{j,3} = sec2HHMM(SlotsRBS(pos,1)*60);
    TableSlotsRBS{j,4} = SlotsRBS(pos,4);
    j = j + 1;
end
    %-> For the GDP
TableSlotsGDP = table(DataA.Number,DataA.ETA,zeros(length(DataA.ETA),2),char('U'*ones(length(DataA.ETA),1)),zeros(length(DataA.ETA),1),'VariableNames',{'ID','ETA','CTA','TypeofDelay','Delay'});
j = 1;
for i = 1:length(TableSlotsGDP{:,1})
    pos = find(TableSlotsGDP{i,1} == SlotsGDP(:,3));
    TableSlotsGDP{j,3} = [SlotsGDP(pos,1) SlotsGDP(pos,2)];
    TableSlotsGDP{j,5} = SlotsGDP(pos,4);
    if SlotsGDP(pos,5) == 1
        TableSlotsGDP{j,4} = 'A';
    elseif SlotsGDP(pos,5) == 2
        TableSlotsGDP{j,4} = 'G';
    end
    j = j + 1;
end

%Computing the total, maximum, average delay (Airborne and Ground)
    %->AirDelay - RBS only
Amount(1,1) = length(find(SlotsRBS(:,3) > 0));
Max(1,1) = max(SlotsRBS(:,4));
Total(1,1) = sum(SlotsRBS(:,4));
Av(1,1) = sum(SlotsRBS(:,4))/length(find(SlotsRBS(:,3) > 0));
    %->AirDelay
Amount(2,1) = length(find(AirDelay(:,1) > 0));
Max(2,1) = max(AirDelay(:,2));
Total(2,1) = sum(AirDelay(:,2));
Av(2,1) = sum(AirDelay(:,2))/length(find(AirDelay(:,1) > 0));
    %->GroundDelay
Amount(3,1) = length(find(GroundDelay(:,1) > 0));
Max(3,1) = max(GroundDelay(:,2));
Total(3,1) = sum(GroundDelay(:,2));
Av(3,1) = sum(GroundDelay(:,2))/length(find(GroundDelay(:,1) > 0));
    % Creating a table
TableDelay = table(Amount,Max,Av,Total,'RowNames',{'Air Delay (RBS-only)';'Air Delay';'Ground Delay'}); TableDelay(:,:)
