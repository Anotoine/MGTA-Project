function [slots, GroundDelay, AirDelay] = assignSlots (slots, ETA, Controlled, Excluded)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [slots, GroundDelay, AirDelay] = assignSlots (Slots, DataA.ETA, Controlled, Excluded) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    AirDelay = [];
    GroundDelay = [];
    
    j = 1;     
    SlotHI = slots(1,1)*60+slots(1,2);
    SlotHF = slots(end,1)*60+slots(end,2);
    
    for i = 1:length(Excluded)
        ETAH = ETA(Excluded(i),1)*60+ETA(Excluded(i),2);
        if ETAH >= SlotHI && ETAH <= SlotHF
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
    end
    
    j = 1;
    for i = 1:length(Controlled)
        ETAH = ETA(Controlled(i),1)*60+ETA(Controlled(i),2);
        if ETAH >= SlotHI && ETAH <= SlotHF
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
end
