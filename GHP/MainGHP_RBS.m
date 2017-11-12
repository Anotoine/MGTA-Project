%Main GHP (Study not taking into account the Connection Passengers)

clearvars;
load('DataArrivals.mat')
Hstart = 660;   %11 00 AM - Start of the regulation
Hend = 780;     %01 00 PM - End of the regulation
Hfinal = 1148;  %07 08 PM - End of the data to analise (later than the real data to have some slots, just in case)
epsilon = 0;    %Linear cost of the delay
ETA = DataA.ETA(:,1)*60 + DataA.ETA(:,2); % Time in minutes

t = ETA(1):Hfinal; %Slots from the first one on the day to the last one
T = length(t);
b = zeros(1,T/3);
r = ones(1,length(ETA)); % In order to make an RBS the r (related with the cost) must remain constant to 1

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

x = GHP(ETA,r,t,b,epsilon); %Running the function of the GHP
