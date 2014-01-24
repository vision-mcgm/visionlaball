function [ s ] = getAll( t )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
s='';
while t.BytesAvailable
    rawData=fread(t,1,'double');
    s=[s char(rawData)];
end
end

