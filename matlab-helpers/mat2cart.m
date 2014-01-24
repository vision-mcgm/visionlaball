function [ xy ] = mat2cart( i,j,maxy )
%Converts from Matlab format (yfirst,y-down) to Cartesian format
%(xfirst,y-up)

x=j;
y=maxy-i;

xy=[x y];

end

