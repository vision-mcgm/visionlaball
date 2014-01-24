function [ a,b,c ] = right_mcgm(a1,a2,a3,a4,a5 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if isCluster
    [a,b,c]=mcgm2(a1,a2,a3,a4,a5);
else
    [a,b,c]=mcgm2_32_RSSE(a1,a2,a3,a4,a5);
end
    
end

