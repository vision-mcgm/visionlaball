function [ im_out ] = wipeOval_matrix( im,x,y,w,h )
%This is built to take a 2d MATRIX
%Inputs are RADIUS MEASURE.

width=size(im,2);
height=size(im,1);

clear equation
horiz=60;
vert=60;

dmax=0;
atanmax=0;
% for ix=1:width
%     for iy=1:height

im_out=zeros(height,width);

for ix=x-w:x+w
    for iy=y-h:y+h
        %Get angle
        angle=atan2(y-iy,x-ix);
        angles(ix,iy)=angle;
        %Get distance to ellipse border
        a=w;
        b=h;
        distances(ix,iy)=(a*b)/(sqrt((b*cos(angle))^2 + (a*sin(angle))^2));
        if distances(ix,iy) > dmax
            dmax = distances(ix,iy);
        end
        
         if angles(ix,iy) > atanmax;
            atanmax = angles(ix,iy);
         end
        
         
         pointDist=dist(x,y,ix,iy);
         
         thisPt=im(iy,ix,:);
         
         borderDist=distances(ix,iy);
         thisPt=wipeFunc(thisPt,borderDist,pointDist);
         
         im(iy,ix,:)=thisPt; %When declaring an image, don't forget RGB channels
         
         
         
         
         %im_out=im(y-h:y+h,x-w:x+w,:);
         
        
        
        
    end
end

im_out(y-h:y+h,x-w:x+w,:)=im(y-h:y+h,x-w:x+w,:);

% for ix=x-w:x+w
%     for iy=y-h:y+h
%         %Get angle
%         equation(ix,iy)=angles(ix,iy)/atanmax;
%         
%         
%         
%         
%     end
% end

%imshow(imScale(equation));

end

function d = dist(x1,y1,x2,y2)
d=sqrt((x2-x1)^2 + (y2-y1)^2);
end


function out=wipeFunc(point,borderDist,pointDist)
fadeOut=10;
if pointDist > borderDist
    out=0;

else
    out=point;
end
end

