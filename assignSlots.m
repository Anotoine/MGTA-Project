function [slots, GroundDelay, AirDelay] = assignSlots (slots, ETA, Controlled, Excluded)
    
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
                AirDelay(end,1) = Excluded(i);
                AirDelay(end,2) = slotH - ETAH;
                encontrado = true;
            end
            j = j + 1;
        end
    end
    
    j = 1;
    for i = 1:length(ETA)
        if (Controlled(i))
            ETAH = ETA(Excluded(i),1)*60+ETA(Excluded(i),2);

            encontrado = false;
            while ~encontrado            
                slotH = slots(j,1)*60+slots(j,2);
                if ((ETAH <= slotH) && (slots(j,3) == 0))
                    slots(j,3) = Excluded(i);
                    GroundDelay(end,1) = Excluded(i);
                    GroundDelay(end,2) = slotH - ETAH;
                    encontrado = true;
                end
                j = j + 1;
            end
            
        end
    end
end
