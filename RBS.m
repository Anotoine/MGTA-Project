function [Slots] = RBS (Name, ETA, Hstart, Hend, slot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Slots = RBS(DataA.Number, DataA.ETA, 11, 13, 3);  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    close

    ETA = minute(ETA) + hour(ETA)*60;
    DataIn(:,1) = Name;
    DataIn(:,2) = ETA;
    Slots(:,1) = [ETA(1):1:Hstart*60 Hstart*60:slot:Hend*60 (Hend*60)+1:1:ETA(end)];
    
    i = 1;
    for j = 1:length(Slots)
        if (DataIn(i,2) <= Slots(j))
            Slots(j,2) = DataIn(i,2);
            Slots(j,3) = DataIn(i,1);
            Slots(j,4) = Slots(j,1)-Slots(j,2);
            i = i + 1;
        end
    end
    figure('name','Ration By Schedule');
    plot(Slots(:,1)/60,Slots(:,4),'b-d')
%     hold on;
%     stem(Slots(:,1)/60,Slots(:,4))
    title('Ration by Schedule');xlabel('Time (hours)'); ylabel('Delay (min)');
    legend('Delay (min)'); legend('boxoff'); axis([7 19 0 inf]);

end