% RBS function used when applying the GDP (which encompasses the RBS algorithm)
function [Slots, DelayDay, DelayAffected] = RBS (Name, ETA, Hstart, Hend, slot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Slots, Delay] = RBS(DataA.Number, DataA.ETA, 11, 13, 3);  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    DataIn(:,1) = double(Name);
    DataIn(:,2) = ETA(:,2) + ETA(:,1)*60;
    Slots(:,1) = [DataIn(1,2):1:Hstart*60 (Hstart*60)+slot:slot:Hend*60 (Hend*60)+1:1:DataIn(end,2)+10];
    
    i = 1;
    for j = 1:length(Slots)
        if i <= length(DataIn(:,2))
            if (DataIn(i,2) <= Slots(j))
                Slots(j,2) = DataIn(i,2);
                Slots(j,3) = DataIn(i,1);
                Slots(j,4) = Slots(j,1)-Slots(j,2);
                i = i + 1;
            end
        end
    end
    
    DelayAffected = sum(Slots(241:1:404,4));
    DelayDay = sum(Slots(:,4));
    
    figure('name','Ration By Schedule')
    hold on;
    title('Ration by Schedule');xlabel('Time (hours)'); ylabel('Delay (min)');
    plot(Slots(:,1)/60,Slots(:,4),'b-')
    text(0.05,0.95,['Total Delay Day= ', num2str(DelayDay), ' min'],'Units','normalized');
    text(0.05,0.90,['Total Delay Affected= ', num2str(DelayAffected), ' min'],'Units','normalized');
    legend('Delay (min)'); legend('boxoff'); axis([7 19 0 inf]);

end