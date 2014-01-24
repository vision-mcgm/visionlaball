function [ s ] = cmd( t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
m=input('$: ','s');
fwrite(t,[m '@'],'double');
pause(0.1);
s=getAll(t);

end

