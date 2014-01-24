function [ im ] = imCross( im,x,y )
%imCross(im,x,y)
x=round(x);
y=round(y);

d=10;

im(y-d:y+d,x,:)=255;
im(y,x-d:x+d,:)=255;

% im(y-d:y+d,x,1)=min(255,im(y-d:y+d,x,1)+10);
% im(y,x-d:x+d,1)=min(255,im(y,x-d:x+d,1)+10);

end

