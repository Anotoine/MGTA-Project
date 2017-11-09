clearvars
clc

load('DataArrivals.mat')
load('DataDepartures.mat')

% Parse arrivals and create vector
arrivalsStart = posixtime(DataA.ETA(1));
arrivalsPerSlot = [];

numFlight = 1;
arrivalsThisSlot = 0;

while (numFlight < length(DataA.Number))
    
    if (posixtime(DataA.ETA(numFlight)) - arrivalsStart > 14*60)
        arrivalsPerSlot = [arrivalsPerSlot arrivalsThisSlot];
        arrivalsStart = arrivalsStart + 15*60;
        arrivalsThisSlot = 0;
    end
    
    arrivalsThisSlot = arrivalsThisSlot + 1;
    
    numFlight = numFlight + 1;
end

% Parse departures and create vector
departuresStart = posixtime(DataD.ETA(1));
departuresPerSlot = [];

numFlight = 1;
departuresThisSlot = 0;

while (numFlight < length(DataD.Number))
    
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

Ca = ones(1,10)*15; % 60 / 4
Cd = ones(1,10)*5 % 20 / 4
Da = arrivalsPerSlot; 
Dd = departuresPerSlot;

[x1,x2] = AirportCap(Da,Dd,Ca,Cd);

function [A1,A2] = AirportCap(Da, Dd, Ca, Cd)

    A1 = -1*eye(2*length(Da));
    
    for i = length(Da)+1:2*length(Da)
        for j = length(Da)+1:2*length(Da)
            if j <= i
                A2(i,j) = 1;
            end
        end
    end
end