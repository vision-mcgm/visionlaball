function [  ] = checkDir( d )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if ~isdir(d)
    mkdir(d);
end

end

