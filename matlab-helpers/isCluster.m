function [ tf ] = isCluster(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% 
% switch computer
%     case 'PCWIN'
%         tf=0;
%     case 'PCWIN64'
%         tf=1;
%     
% end

if isdir('C:\NotCluster')
    tf=0;
else
    tf=1;
end

end

