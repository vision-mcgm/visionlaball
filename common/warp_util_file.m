function [ Vx,Vy ] = warp_util_file( fImage,fRef )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[Vx,Vy] = warp_util(imread(fImage),imread(fRef));
end

