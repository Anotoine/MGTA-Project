clearvars; clc; %Erasing all the variables and the command window

load('..\DataArrivalsDatetime.mat') %Loading the Data from Arrivals
load('..\DataDeparturesDatetime.mat') %Loading the Data from Departures

% Parse arrivals and create vector
arrivalsStart = posixtime(datetime(DataA.ETA(123))); %Starting time at 10:05 AM
arrivalsEnd = posixtime(datetime(DataA.ETA(198))); %Ending time at 12:05 PM
arrivalsPerSlot = [];

numFlight = 123; % Aircraft at time 10:05 AM
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
departuresStart = posixtime(datetime(DataD.ETA(159))); %Starting time at 10:05 AM
departuresEnd = posixtime(datetime(DataD.ETA(270))); %Ending time at 12:05 PM
departuresPerSlot = [];

numFlight = 159; % Aircraft at time 10:05 AM
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

Ca = ones(1,length(arrivalsPerSlot))*15; % Capacity Arrivals
Cd = ones(1,length(departuresPerSlot))*20; %Capacity Departures
Da = arrivalsPerSlot; 
Dd = departuresPerSlot;
alpha = 0.7;

[x] = AirportCap(Da,Dd,Ca,Cd,alpha);

%The time slots   (8 with demnad) --> No extra slots added because they are not needed
Time(:,1) = [10;10;10;10;11;11;11;11];
Time(:,2) = [05;20;35;50;05;20;35;50];
Time(:,3) = Time(:,1)+Time(:,2)/60;

%Creation of the table 
TableCapacitySquare = table(Time(:,1),Time(:,2),Da',x(:,1),Da'-x(:,1),Dd',x(:,2),Dd'-x(:,2),...
    'VariableName',{'Hour','Minute','Arrivals','Arrivals_AC','Arrivals_Queue','Departures','Departures_AC','Departures_Queue'});

	%Erasing the values for the queue that are less than 0
for i = 1:length(Time(:,3))
    Arrivals_Q(i) = max(0, min(TableCapacitySquare{i,5}));
    Departures_Q(i) = max(0, min(TableCapacitySquare{i,8}));
end

%Drawing the Queue
figure('name','Queues')
plot(Time(:,3), Arrivals_Q, 'b-d')
hold on;
plot(Time(:,3), Departures_Q, 'r-o')
title(['Queue (\alpha = ' num2str(alpha) ')']);xlabel('Time Slot');ylabel('Amount of Aircraft in the Queue');
legend('Arrival Queue','Departures Queue')

%Computing the Total
Totalline = {0,0,sum(TableCapacitySquare{:,3}),sum(TableCapacitySquare{:,4}),sum(TableCapacitySquare{:,5}),sum(TableCapacitySquare{:,6})...
    sum(TableCapacitySquare{:,7}),sum(TableCapacitySquare{:,8})};

%Total to the table
TableCapacitySquare = [TableCapacitySquare;Totalline];
TableCapacitySquare(:,:)

function [x] = AirportCap(Da, Dd, Ca, Cd, alpha)

%Creation of the A matrix
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
    
	%Creation of the B matrix
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
    
    lb = zeros(1,length(Da)+length(Dd));
    ub = inf*ones(1,length(Da)+length(Dd));
    f = zeros(1,length(Da)+length(Dd));
    intcon = 1:length(Da)+length(Dd);
    
	% Calculus of the cost function
    for i = 1:length(Da)
        f(i) = alpha*(length(Da)-i+1);
        f(i + length(Da)) = (1-alpha)*(length(Da)-i+1);
    end
    f = -f;
    
    x = intlinprog(f,intcon,A,b,[],[],lb,ub);
    
	%Reshaping of the solution to in two rows of the length
    x = reshape(x,[length(Da),2]);
    
	%Representing the solution
    plotACSquare(Da,Dd,Ca(1),Cd(1),x(1:8),x(9:16),alpha);
        
    
end