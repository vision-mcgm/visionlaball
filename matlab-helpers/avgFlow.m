function [ aX,aY ] = avgFlow( TWx,TWy,x,y )
%Returns the average warp vector from a 2n*2n square in the warp field.

n=5;

squareX=TWx(y-n:y+n,x-n:x+n);
squareY=TWy(y-n:y+n,x-n:x+n);

aX=mean(mean(squareX));
aY=mean(mean(squareY));

end

