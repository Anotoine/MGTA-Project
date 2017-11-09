%AirportCapacity
Ca = ones(1,10)*8;
Cd = ones(1,10)*8;
Da = [5 2 10 5 8 8 4 2 0 0]; 
Dd = [4 0  3 6 3 8 2 9 0 0];

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