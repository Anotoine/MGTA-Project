%Test GDP --> Main
HFile = [9 0];
Hstart = [11 0];
Hend = [13 0];

PAAR = 20;
AAR = 60;
Slot = 3;
radius = 1500;
close all;

% [SlotsRBS, DelayRBS] = RBS (Name, ETA, Hstart, Hend, slot)
[SlotsRBS, DelayRBS] = RBS (DataA.Number, DataA.ETA, Hstart, Hend, Slot);

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
plotHistograms(DataA.ETA, CTA, AAR, PAAR, SlotsGDP);

