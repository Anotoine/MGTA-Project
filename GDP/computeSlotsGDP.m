function [Slots] = computeSlotsGDP (HStart, Hend, HNoReg, PAAR, AAR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Slots] = computeSlotsGDP ([11 00], [13 00], [15 03], 20, 60) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    HStart = HStart(1)+HStart(2)/60;
    Hend = Hend(1)+Hend(2)/60;
    HNoReg = HNoReg(1)+(HNoReg(2)/60);

    Slots(:,1) = [7:1/AAR:HStart (HStart + 1/PAAR):1/PAAR:Hend (Hend + 1/AAR):1/AAR:HNoReg (HNoReg + 1/AAR):1/AAR:19.5];    
    Slots(:,3) = zeros(1,length(Slots));
    
    for i = 1:length(Slots)
        Slots(i,2) = int8((Slots(i,1) - fix(Slots(i,1)))*60);
        Slots(i,1) = int8(fix(Slots(i,1)));
    end
    
end