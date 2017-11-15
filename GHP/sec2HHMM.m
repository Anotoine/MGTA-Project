% This function converts a time specified 
% in seconds to the format HH:MM
function [HM,days] = sec2HHMM (sec) 
    [c,r] = size(sec); 
    HM = zeros(c,1);
    days = zeros(c,1);
    for i = 1:c
        d = 0;
        h = fix(sec(i)/3600);
        min = fix(abs(sec(i))/60) - (abs(h)*60);       
        s = abs(sec(i)) - abs((h*3600 + min*60));

        while(h < 0 || min < 0)
            if (h < 0)
                h = h + 24;
                d = d - 1;
            end

            if (min < 0)
                min = min + 60;
            end
        end
        
        HM(i,1) = h;
        HM(i,2) = min;
        days(i) = d;
    end
end