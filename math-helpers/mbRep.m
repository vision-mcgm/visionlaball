function [ im ] = mbRep( x,y )
%Makes Middlebury rep
ni=size(x,1);
nj=size(x,2);
im=zeros(ni,nj,3);

[vel angles]=vecs2out(x,y); %Now we are in down,+-,ACW rep

%upper=max(max(vel));
upper=80;

im(:,:,1)=(angles+180)./360;
im(:,:,2)=0.5%vel./upper;
im(:,:,3)=0.5;

im=hsv2rgb(im);


end

