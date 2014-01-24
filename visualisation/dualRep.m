function [img  ] = dualRep( x,y,varargin )
%Creates a dual-representation (speed and angle) view of a vector field. If
%an image is supplied, this is appended.
%Directions go from pi to 2*pi; norms are normalised to largest norm.

%Params

bordersize=10;

%Code
[i j c]=size(x); %assume y same size

img=zeros(i+bordersize*2, 3*i+bordersize*6,3);
[imi imj c]=size(img);

%Set up colormap



directions=atan2(y,x); %Four-quadrant version of arctan, with separate arguments
xsq=x.*x;
ysq=y.*y;
norms=sqrt(xsq+ysq);

%Fill in borders

%Centre of 3rd square
cx=2.5*i+5*bordersize;
cy=bordersize + 0.5*j;

borderx= [2*i+4*bordersize+1:2*i+5*bordersize 3*i+bordersize*5+1:imj];
bordery=[1:bordersize bordersize+j+1:imi];

img(:,2*i+4*bordersize+1:2*i+5*bordersize,:)=1; %Draw vertical bar 1
img(:,3*i+bordersize*5+1:imj,:)=1; %Draw vertical bar 2
%img(1:bordersize,:,:)=1; %Draw horizontal bar 1
%img(bordersize+j+1:imi,:,:)=1; %Draw horizontal bar 2

%Draw coloured border
%Vertical bar 1
for ix=2*i+4*bordersize+1:2*i+5*bordersize
    for iy=1:imi        
        img(iy,ix,:)=rgbFromAngle(atan2(-(iy-cy),ix-cx));
    end
end
%Vertical bar 2
for ix=3*i+bordersize*5+1:imj
    for iy=1:imi
        img(iy,ix,:)=rgbFromAngle(atan2(-(iy-cy),ix-cx));
    end
end
%H bar 1
for ix=2*i+4*bordersize+1:imj
    for iy=1:bordersize
        img(iy,ix,:)=rgbFromAngle(atan2(-(iy-cy),ix-cx));
    end
end
%H bar 2
for ix=2*i+4*bordersize+1:imj
    for iy=bordersize+j+1:imi
        img(iy,ix,:)=rgbFromAngle(atan2(-(iy-cy),ix-cx));
    end
end

imshow img

end

function [rgb]=rgbFromAngle(t)
if t<0,t=t+2*pi;,end
tau=pi*2;
rgb=hsv2rgb(t/tau,0.75,0.75);
%rgb=t;
end