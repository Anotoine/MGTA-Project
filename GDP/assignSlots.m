% Assigns slots to the different flights
% when applying a GDP regulation
function [slots, GroundDelay, AirDelay] = assignSlots (slots, ETA, Controlled, Excluded)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [slots, GroundDelay, AirDelay] = assignSlots (Slots, DataA.ETA, Controlled, Excluded) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    AirDelay = [];
    GroundDelay = [];
    
    if Excluded(1) ~= 0
        j = 1;         
        i = 1;
        while i <= length(Excluded)
            if  Excluded(i) ~= 0
                ETAH = ETA(Excluded(i),1)*60+ETA(Excluded(i),2);
                encontrado = false;
                while ~encontrado
                    slotH = slots(j,1)*60+slots(j,2);
                    if (ETAH <= slotH)
                        slots(j,3) = Excluded(i);
                        slots(j,4) = slotH - ETAH;
                        slots(j,5) = 1; %the 1 means that the delay is AirDelay
                        AirDelay(end+1,1) = Excluded(i);
                        AirDelay(end,2) = slotH - ETAH;
                        encontrado = true;
                    end
                    j = j + 1;
                end
            end
            i = i + 1;
        end
    end
    
    if Controlled(1) ~= 0
        j = 1;
        i = 1;
        while i <= length(Controlled)
            if  Controlled(i) ~= 0
                ETAH = ETA(Controlled(i),1)*60+ETA(Controlled(i),2);
                encontrado = false;
                while ~encontrado            
                    slotH = slots(j,1)*60+slots(j,2);
                    if ((ETAH <= slotH) && (slots(j,3) == 0))
                        slots(j,3) = Controlled(i);
                        slots(j,4) = slotH - ETAH;
                        slots(j,5) = 2; %the 2 means that the delay is GroundDelay
                        GroundDelay(end+1,1) = Controlled(i);
                        GroundDelay(end,2) = slotH - ETAH;
                        encontrado = true;
                    end
                    j = j + 1;
                end
            end
            i = i + 1;
        end
    end
    
    %Checking that both are of the same length with ETA
    if length(AirDelay) < length(ETA)
        AirDelay = [AirDelay; zeros(length(ETA)-length(AirDelay),2)];
    end
    if length(GroundDelay) < length(ETA)
        GroundDelay = [GroundDelay; zeros(length(ETA)-length(GroundDelay),2)];
    end
    
end
