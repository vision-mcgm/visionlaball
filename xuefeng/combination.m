function [output] = combination(v,k)
%COMBINATION Summary of this function goes here
%   caculate combinations of v elements when choose k.
    switch sign(v-k)
        case -1
            output = 0;
        case 0
            output = 1;
        otherwise                   
            output = factorial(v)/(factorial(v-k)*factorial(k));
    end
end

