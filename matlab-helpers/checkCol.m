function [ v ] = checkCol( v )
%Checks vec is colvec

if size(v,2)>1
    v=v';
end


end

