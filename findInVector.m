% This function finds an element inside a vector
% to make searches easier and write less lines of code
function [found] = findInVector (vector, stringToFind)

    i = 1;
    found = false;
    while (i <= length(vector))
        
        if (string(vector(i)) == string(stringToFind))
            found = true;
            break;
        end
        i = i + 1;
    end
    
end