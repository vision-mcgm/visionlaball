function [ ij ] = cart2mat( x,y,maxy )
%Converts from mat to cart, in both ORDER and which direction we count the
%Y's

j=x;
i=maxy-y;
ij=[i j];

end

