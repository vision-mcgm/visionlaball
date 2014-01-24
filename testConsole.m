function [  ] = testConsole(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
while 1
s=input('Enter command: ','s');
eval(s);
end
end

