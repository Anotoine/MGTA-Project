function [slots, GroundDelay, AirDelay] = assignSlots (slots, ETA, Controlled, Excluded)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [slots, GroundDelay, AirDelay] = assignSlots (Slots, DataA.ETA, Controlled, Excluded) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    AirDelay = [];
    GroundDelay = [];
    
    j = 1;         
    for i = 1:length(Excluded)
        ETAH = ETA(Excluded(i),1)*60+ETA(Excluded(i),2);
        encontrado = false;
        while ~encontrado
            slotH = slots(j,1)*60+slots(j,2);
            if (ETAH <= slotH)
                slots(j,3) = Excluded(i);
                AirDelay(end+1,1) = Excluded(i);
                AirDelay(end,2) = slotH - ETAH;
                encontrado = true;
            end
            j = j + 1;
        end
    end
    
    j = 1;
    for i = 1:length(Controlled)
        ETAH = ETA(Controlled(i),1)*60+ETA(Controlled(i),2);
        encontrado = false;
        while ~encontrado            
            slotH = slots(j,1)*60+slots(j,2);
            if ((ETAH <= slotH) && (slots(j,3) == 0))
                slots(j,3) = Controlled(i);
                GroundDelay(end+1,1) = Controlled(i);
                GroundDelay(end,2) = slotH - ETAH;
                encontrado = true;
            end
            j = j + 1;
        end
    end
end
