function [ Vx,Vy ] = pixelPos2Vector( TPx,TPy )
%Converts 2-component warp field from pixel pos to vector representation
%TESTED: works in the righ direction (Doesn't invert fields or anything).

[h w] = size(TPx);

col=(1:h)';
row=1:w;

coordsY=repmat(col,1,w);
coordsX=repmat(row,h,1);

Vx=TPx-coordsX;
Vy=TPy-coordsY;

end

