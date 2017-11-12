function [x] = GHP(e,r,t,b,epsilon)
%%%
%Function about the calculus of the GHP.
%%%

%INPUTS:
% - e: ETA of all the planes planned to arrive
% - r: factor of cost (multiplies by the delay that the plane will have)
% - t: Slots during the time that the GHP should work (It is recommend to add some slots at the end, just in case ;))
% - b: capacity (per Slot)
% - epsilon: exponent of the delay. For cuadratic delay, epsilon = 1.

%OUTPUTS:
% - x: is the amount of planes that should land per Slot (rows->flights, columns->slots)


    F = length(e);
    T = length(t);

    Aeq = zeros(F,T*F);
    beq = ones(F,1);
    A = zeros(T/3,T);
    b = b';
    c = zeros(1,F*T);
    ub = ones(1,F*T);
    lb = zeros(1,F*T);
    intcon = 1:(F*T);
    i = 1;
    j = 1;
    
   while i <= T
        while  j <= T/3

            A (j, i) = 1;
            A (j, i + 1) = 1;
            A (j, i + 2) = 1;

            i = i + 3;
            j = j +1;
        end
   end
    A = [A; eye(T,T)];
    A = repmat(A,[1,F]);
    
    i = 1;
    j = 1;
    
    while i <= F
        while j <= T
            
            Aeq (i, j + T*(i-1)) = 1;

            if t(j)-e(i) < 0
                c (j + T*(i-1)) = 10e10;
            else
                c (j + T*(i-1)) = r(i)*power((t(j)-e(i)),epsilon+1);
            end
            j = j + 1;
        end
        i = i + 1;
        j = 1;
    end

     x = intlinprog(c,intcon,A,b,Aeq,beq,lb,ub);
    
     x = reshape(x,[T,F]);
    end