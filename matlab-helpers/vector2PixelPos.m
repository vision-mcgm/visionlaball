function [ Px,Py ] = vector2PixelPos( Vx,Vy )
%Converts vector to pixel pos representation
%TESTED: works in the righ direction (Doesn't invert fields or anything).


[h w] = size(Vx);

col=(1:h)';
row=1:w;

coordsY=repmat(col,1,w);
coordsX=repmat(row,h,1);

Px=Vx+coordsX;
Py=Vy+coordsY;

end

