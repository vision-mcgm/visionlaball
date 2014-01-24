function [ out ] = numericalSortStruct( s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(s,1)
    names(i)=str2num(s(i).name);
end

[b,ix]=sort(names);

for i=1:size(s,1)
    out(i)=s(ix(i));
end
    
end

