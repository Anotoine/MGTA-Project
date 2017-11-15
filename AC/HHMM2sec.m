% This function converts a time specified 
% in the format HH:MM to seconds
function [sec] = HHMM2sec (HM) 
    [c,r] = size(HM); 
    sec = zeros(c,1);
    for i = 1:c
        if r ~= 2
            disp('Error the input must be [HH MM]') 
            sec = NaN;
            return;
        end
        sec(i,1) = HM(i,1)*3600 + HM(i,2)*60;
    end
end