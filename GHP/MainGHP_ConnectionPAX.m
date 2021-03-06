%Main GHP (Study taking into account the Connection People)

clearvars;
load('..\DataArrivals.mat')
Hstart = 660;   %11 00 AM - Start of the regulation
Hend = 780;     %01 00 PM - End of the regulation
Hfinal = 1148;  %07 08 PM - End of the data to analise (later than the real data to have some slots, just in case)
epsilon = 0;    %for linear cost of the delay = 0, for a cuadratic cost = 1, for a cubic = 2,...
ETA = DataA.ETA(:,1)*60 + DataA.ETA(:,2); % Time in minutes

t = ETA(1):Hfinal; %Slots from the first one on the day to the last one
T = length(t);
b = zeros(1,T/3);

%Computing the Connection passengers ratio
Conn = double(DataA.CPAX);
r = (Conn - min(Conn))/(max(Conn) - min(Conn)) + 1;
%To normalize r (+1) with the connections

i = 1; %Creating b with the capacities (between 3 and 1, depending on the PAAR and AAR)
for j = 1:T/3
    if t(i) >= Hstart && t(i) <= Hend
        b(j) = 1;    
        i = i + 3;
    else
        b(j) = 3; 
        i = i + 3;
    end
end
b = [b, ones(1,T)]; %Adding a row of ones

[x, Slots, Cost] = GHP(ETA,r,t,b,epsilon); %Running the function of the GHP

%-> For the GHP
TableSlotsGHP = table(DataA.Number,DataA.ETA,zeros(length(DataA.ETA),2),zeros(length(DataA.ETA),1),zeros(length(DataA.ETA),1),zeros(length(DataA.ETA),1),...
    'VariableNames',{'ID','ETA','CTA','ConnectionPassengers','Cost','Delay'});
TableSlotsGHP{:,6} = Slots(:,3);
TableSlotsGHP{:,5} = Cost';
TableSlotsGHP{:,4} = Conn(:);
TableSlotsGHP{:,3} = sec2HHMM(Slots(:,2)*60); TableSlotsGHP(:,:)
% Finding the results
Amount = length(TableSlotsGHP{:,1});
Max = max(TableSlotsGHP{:,6});
Total = sum(TableSlotsGHP{:,6});
Av = Total/Amount;
TotalCost = sum(Cost);

% Creating a table
TableDelay = table(Amount,Max,Av,Total,TotalCost,'RowNames',{'GHP'}); TableDelay(:,:)

figure(2)
plot(1:length(ETA),r)

plotHistograms(ETA,Slots(:,2),60,20)
