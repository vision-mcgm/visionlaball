function [  ] = altixErr( m )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

err=MException('ResultChk:BadInput',m)
throw(err)
end

