function [  ] = ph( d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%d(d<xmin)=xmin;
%d(d>xmax)=xmax;
figure(8)
subplot(2,1,1);
hist(d(:));
title('Histogram')
subplot(2,1,2);
imagesc(d)
colorbar
title('Image')

end

