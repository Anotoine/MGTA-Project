function [Slots] = computeSlotsGDP (HStart, Hend, HNoReg, PAAR, AAR)

    Slots(:,1) = [(HStart(1)+HStart(2)/60):1/PAAR:(Hend(1)+Hend(2)/60) (Hend(1)+(1/PAAR)+Hend(2)/60):1/AAR:(HNoReg(1)+(HNoReg(2)+20)/60)];    
    Slots(:,3) = zeros(1,length(Slots));
    
    for i = 1:length(Slots)
        Slots(i,2) = int8((Slots(i,1) - fix(Slots(i,1)))*60);
        Slots(i,1) = int8(fix(Slots(i,1)));
    end
    
end