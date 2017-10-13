function [NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled] = computerAircraftStatus (ETA, ETD, Distances, International, HFile, Hstart, HNoReg, radius)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled] = computerAircraftStatus (DataA.ETA, DataA.ETD, DataA.Distance, DataA.Int, [9 0], [11 0], [15 03], 1000)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    NotAffected = [];
    ExcludedRadius = [];
    ExcludedInternational = [];
    ExcludedFlying = [];
    Excluded = [];
    Controlled = [];
    ETA = ETA(:,2) + ETA(:,1)*60;
    ETD = ETD(:,2) + ETD(:,1)*60;
    Hstart = Hstart(2) + Hstart(1)*60;
    HFile = HFile(2) + HFile(1)*60;
    HNoReg = HNoReg(2) + HNoReg(1)*60;
    
    i = 1;
    while i <= length(ETA)
        
        IsExcluded = false;
        if ((ETA(i) < Hstart) || (ETA(i) > HNoReg))
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