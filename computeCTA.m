function CTA = computeCTA(ETA, GroundDelay, AirDelay)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CTA = computeCTA(ETA, GroundDelay, AirDelay) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ETA = ETA(:,2) + ETA(:,1)*60;
    for i = 1:length(ETA)
        pos = find(GroundDelay == i);
        if (pos == [])
            pos = find(AirDelay == i);
            ETA(i) = ETA(i) +  AirDelay(pos);
        elseif ~(pos == [])
            ETA(i) = ETA(i) +  AirDelay(pos);
        end
    end
end