function [NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying ExcludedControlled] = computerAircraftStatus (ETA, ETD, Distances, International, Hfile, Hstart, HNoReg, radius)
    
    NotAffected = [];
    ExcludedRadius = [];
    ExcludedInternational = [];
    ExcludedFlying = [];
    ExcludedControlled = [];
    
    i = 1;
    while i <= length(ETA)
        
        IsExcluded = false;
        if (ETA(i) < Hstart)
            NotAffected = [NotAffected i];
            IsExcluded = true;
        end
        
        if (Distances(i) > radius)
            ExcludedRadius = [ExcludedRadius i];
            IsExcluded = true;
        end
        
        if (ETD(i) < HFile)
            ExcludedFlying = [ExcludedFlying i];
            IsExcluded = true;
        end
        
        if (International(i))
            ExcludedInternational = [ExcludedInternational i];
            IsExcluded = true;
        end
        
        if (IsExcluded)
            Excluded = [Excluded i];
        else
            Controlled = [Controlled i];
        end
        
        i = i + 1;
    end

end