function [ shot vel angles ] = mcgmHelper( source,target )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mcgmcpp = 1.5;
	mcgmconv = 23;
	mcgmthresh = 0.1;


 [shot vel angles]=mcgm2(source, target, mcgmcpp, mcgmconv, mcgmthresh);

end

