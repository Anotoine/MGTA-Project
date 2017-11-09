function plotHistograms(ETA, CTA, AAR, PAAR, Slots)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotHistograms(ETA, CTA, 60, 30) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Capacity1(:,1) = 7:11;
    Capacity1(:,2) = AAR;
    Capacity2(:,1) = 11:13;
    Capacity2(:,2) = PAAR;
    Capacity3(:,1) = 13:19;
    Capacity3(:,2) = AAR;
    
    ETAH = ETA(:,1) + ETA(:,2)/60;
    CTAH = CTA(:,1) + CTA(:,2)/60;

    edges = 7:1:19;

    figure('name','ETA, CTA')
    ylim([0 80])
    subplot(1,2,1)
    histogram(floor(ETAH),edges,'Normalization','count')
    hold on;
    plot(Capacity1(:,1),Capacity1(:,2),'g')
    plot(Capacity2(:,1),Capacity2(:,2),'r')
    plot(Capacity3(:,1),Capacity3(:,2),'g')
    legend('ETA','AAR','PAAR','AAR','location','southeast')
    title('Histogram arrivals non-regulated traffic'); ylim([0 70]);
    xlabel('Time (hours)'); ylabel('Arrivals (# Aircrafts)');
    subplot(1,2,2)
    histogram(floor(CTAH),edges,'Normalization','count','FaceColor','r')
    hold on;
    plot(Capacity1(:,1),Capacity1(:,2),'g')
    plot(Capacity2(:,1),Capacity2(:,2),'r')
    plot(Capacity3(:,1),Capacity3(:,2),'g')
    legend('CTA','AAR','PAAR','AAR','location','southeast')
    title('Histogram arrivals regulated traffic'); ylim([0 70]);
    xlabel('Time (hours)'); ylabel('Arrivals (# Aircrafts)');
    
%     figure('name','ETA-CTA')
%     histogram(CTAH,edges);
%     hold on;
%     histogram(ETAH,edges);
%     plot(Capacity1(:,1),Capacity1(:,2),'g')
%     plot(Capacity2(:,1),Capacity2(:,2),'r')
%     plot(Capacity3(:,1),Capacity3(:,2),'g')
%     legend('CTA','ETA','AAR','PAAR','AAR','location','southeast')
%     title('Difference between ETA and CTA');
%     xlabel('Time (hours)'); ylabel('Arrivals (# Aircrafts)');
end