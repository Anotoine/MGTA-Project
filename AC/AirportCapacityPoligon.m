clearvars
clc

load('..\DataArrivalsDatetime.mat')
load('..\DataDeparturesDatetime.mat')

% Parse arrivals and create vector
arrivalsStart = posixtime(datetime(DataA.ETA(123))); %10:05 AM
arrivalsEnd = posixtime(datetime(DataA.ETA(198))); %12:05 PM
arrivalsPerSlot = [];

numFlight = 123;
arrivalsThisSlot = 0;

while (numFlight < length(DataA.Number) && posixtime(DataA.ETA(numFlight)) < arrivalsEnd)
    
    if (posixtime(DataA.ETA(numFlight)) - arrivalsStart > 14*60)
        arrivalsPerSlot = [arrivalsPerSlot arrivalsThisSlot];
        arrivalsStart = arrivalsStart + 15*60;
        arrivalsThisSlot = 0;
    end
    
    arrivalsThisSlot = arrivalsThisSlot + 1;
    
    numFlight = numFlight + 1;
end

% Parse departures and create vector
departuresStart = posixtime(datetime(DataD.ETA(159))); %10:05 AM
departuresEnd = posixtime(datetime(DataD.ETA(270))); %12:05 PM
departuresPerSlot = [];

numFlight = 159;
departuresThisSlot = 0;

while (numFlight < length(DataD.Number)  && posixtime(DataD.ETA(numFlight)) < departuresEnd)
    
    if (posixtime(DataD.ETA(numFlight)) - departuresStart > 14*60)
        departuresPerSlot = [departuresPerSlot departuresThisSlot];
        departuresStart = departuresStart + 15*60;
        departuresThisSlot = 0;
    end
    
    departuresThisSlot = departuresThisSlot + 1;
    
    numFlight = numFlight + 1;
end

% Ensure that both the arrivals and the
% departures vector have the same length

if (length(arrivalsPerSlot) == length(departuresPerSlot))
    %Tis alright
elseif (length(arrivalsPerSlot) > length(departuresPerSlot))
    lengthDiff = length(arrivalsPerSlot) - length(departuresPerSlot);
    
    for i = 1:lengthDiff
        departuresPerSlot = [departuresPerSlot 0];
    end
elseif (length(arrivalsPerSlot) < length(departuresPerSlot))
    lengthDiff = length(departuresPerSlot) - length(arrivalsPerSlot);
    
    for i = 1:lengthDiff
        arrivalsPerSlot = [arrivalsPerSlot 0];
    end
end

% Airport Capacity, There We Go.

Ca = ones(1,length(arrivalsPerSlot))*15; % 60 / 4  % 20 / 4
Cd = ones(1,length(departuresPerSlot))*10;
Da = arrivalsPerSlot; 
Dd = departuresPerSlot;

[x] = AirportCap(Da,Dd,Ca,Cd,1);

function [x] = AirportCap(Da, Dd, Ca, Cd, alpha)

    A1 = eye(length(Da)+length(Dd));
    
    for i = 1:length(Da) %rows
        for j = 1:length(Da) %columns
            if (j <= i)
                A2(i,j) = 1;
            end
        end
    end
    
    A = [A2 zeros(length(Da),length(Dd)); zeros(length(Da),length(Dd)) A2];
    A = [A1; A];
    
    %%%
    A = [A; [eye(8), eye(8)]];
    %%%
    
    b = [Ca, Cd];
    lenB = length(b);
    sumA = 0;
    sumD = 0;
    for i = lenB+1:lenB+length(Da)+length(Dd)
        if(i <= length(Da) + lenB)
            sumA = sumA + Da(i-lenB);
            b(i) = sumA;
        else
            sumD = sumD + Dd(i-lenB-length(Da));
            b(i) = sumD;
        end
    end
    
    %%%
    b = [b ones(1,8)*21];
    %%%
    
    lb = zeros(1,length(Da)+length(Dd));
    ub = inf*ones(1,length(Da)+length(Dd));
    f = zeros(1,length(Da)+length(Dd));
    intcon = 1:length(Da)+length(Dd);
    
    for i = 1:length(Da)
        f(i) = alpha*(length(Da)-i+1);
        f(i + length(Da)) = (1-alpha)*(length(Da)-i+1);
    end
    f = -f;
    
    x = intlinprog(f,intcon,A,b,[],[],lb,ub);
    
    
    plotACPoligon(Da,Dd,Ca(1),Cd(1),x(1:8),x(9:16),alpha);
        
    
end