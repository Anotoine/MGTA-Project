function CTA = computeCTA(ETA, GroundDelay, AirDelay)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CTA = computeCTA(ETA, GroundDelay, AirDelay) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ETA = ETA(:,2) + ETA(:,1)*60;
    CTA = ETA;
    for i = 151:length(CTA)
        pos = [];
        pos = find(GroundDelay(:,1) == i);
        if isempty(pos)
            pos = find(AirDelay(:,1) == i);
            if ~isempty(pos)
                CTA(i) = ETA(i) +  AirDelay(pos,2);
            end
        elseif ~isempty(pos)
            CTA(i) = ETA(i) +  GroundDelay(pos,2);
        end
    end
    
    CTA = sec2HHMM(CTA(:)*60);
    
end