function [  ] = pr( d,xmin,xmax )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

d(d<xmin)=xmin;
d(d>xmax)=xmax;
figure(7)
imagesc(d)
colorbar

end

