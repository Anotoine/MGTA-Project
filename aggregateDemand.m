 function [HNoReg, delay] = aggregateDemand(ETA, Hstart, Hend, PAAR, AAR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [HNoReg,delay] = aggregateDemand(DataA.ETA,11,13,20,60)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    close

    ETA = ETA(:,2) + ETA(:,1)*60;
    AggregatedDemand = [0 0];
    AggregatedDemandAAR = [];
    
    sum = 0;
    ETAStart = ETA(1);
    for i = 1:length(ETA)
        if (ETA(i) >= ETAStart+1)
            AggregatedDemand(end+1,1) = ETA(i)-ETA(1);
            AggregatedDemand(end,2) = sum;
            ETAStart = ETA(i);
        end
        sum = sum + 1;
    end
    AggregatedDemand(end+1,1) = (ETA(i)-ETA(1))+5;
    AggregatedDemand(end,2) = sum;

    findValue = Hstart*60-ETA(1);
    for i = 1:length(AggregatedDemand)
        if (AggregatedDemand(i,1) >= findValue)
            AggDemandHstart = AggregatedDemand(i,2);
            break;
        end
    end
    
    AggregatedDemandPAAR = [(Hstart*60-ETA(1)) AggDemandHstart+(PAAR/60)];
    for i = 1:(Hend-Hstart)*60
        AggregatedDemandPAAR(end+1,1) = (Hstart*60-ETA(1))+i;
        AggregatedDemandPAAR(end,2) = AggregatedDemandPAAR(end-1,2) + (PAAR/60);
    end
    
    hasCrossed = false;
    AggregatedDemandAAR(1,1) = AggregatedDemandPAAR(end,1);
    AggregatedDemandAAR(1,2) = AggregatedDemandPAAR(end,2);
    
    i = 1;
    while (~hasCrossed)
        AggregatedDemandAAR(end+1, 1) = AggregatedDemandAAR(end, 1)+1;
        AggregatedDemandAAR(end, 2) = AggregatedDemandAAR(end-1, 2) + AAR/60;
        
        for i = 1:length(AggregatedDemand)
            if (AggregatedDemand(i,1) >= AggregatedDemandAAR(end,1))
                absoluteTime = i;
                break;
            end
        end
        
        if (AggregatedDemandAAR(end, 2) >= AggregatedDemand(absoluteTime, 2))
            hasCrossed = true;
        end
    end
    
    HNoReg = sec2HHMM(ETA(1)*60+AggregatedDemandAAR(end, 1)*60);
    count1 = 1; count2 = 1; sum = 0;
    for i = 75:length(AggregatedDemand)
        if (AggregatedDemand(i,1) >= (Hstart*60)-ETA(1) && AggregatedDemand(i,1) < (Hend*60)-ETA(1))
            d = AggregatedDemand(i,2) - AggregatedDemandPAAR(count1,2);
            sum = sum + d;
            count1 = count1 + 1;
        elseif (AggregatedDemand(i,1) >= (Hend*60)-ETA(1) && AggregatedDemand(i,1) < (HNoReg(1)*60+HNoReg(2))-ETA(1))
            d = AggregatedDemand(i,2) - AggregatedDemandAAR(count2,2);
            sum = sum + d;
            count2 = count2 + 1;
        end
    end
    delay = sum;
    

    AggregatedDemand(:,1) = (AggregatedDemand(:,1)/60)+ETA(1)/60;
    AggregatedDemandPAAR(:,1) = (AggregatedDemandPAAR(:,1)/60)+ETA(1)/60;
    AggregatedDemandAAR(:,1) = (AggregatedDemandAAR(:,1)/60)+ETA(1)/60;
    
    figure('name','Aggregated Demand')
    hold on;
    plot(AggregatedDemand(:,1), AggregatedDemand(:,2),'b')
    plot(AggregatedDemandPAAR(:,1), AggregatedDemandPAAR(:,2),'g')
    plot(AggregatedDemandAAR(:,1), AggregatedDemandAAR(:,2),'r')
    title('Aggregated Demand'); xlabel('Time (hours)'); ylabel('Demand (# Aircraft)');
    legend('Aggregated Demand','PAAR','AAR','Location','northwest'); legend('boxoff');  axis([7 19 0 inf]);
    
    
 end