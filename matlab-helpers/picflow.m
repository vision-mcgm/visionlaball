function [x]=picflow(image,Vx,Vy,step)
% function h=picflow(image,Vx,Vy,step)
% superimposes a quiver plot with vector components (Vx,Vy) on
% image specified. step indicates how sparse the field is to be.

[h w p] = size(image);

[xvals yvals] = meshgrid(1+round(step/2):step:w, 1+round(step/2):step:h);

%h=gcf;
%clf

colormap(gray);
imagesc(image);
hold on;
 %Set axes so that the images are all the same size, otherwise overflowing arrows make size change
quiver(xvals,yvals,...
    Vx(1+round(step/2):step:h,1+round(step/2):step:w),...
    Vy(1+round(step/2):step:h,1+round(step/2):step:w),0,'r','Color','blue');
%axis([0 w 0 h]);
axis off; axis equal;%axis image;
h=gcf;
x = hardcopy(h, '-Dzbuffer', '-r0');
%x=0