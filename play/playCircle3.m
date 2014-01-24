%Given a variable radLimits, masks an image and transforms back into
%non-polar coords.

%Working with doubles. Expects a uint8 though.
%REQUIREMENTS: playCircle has been run first to set params.



im=polarImage;
im=double(im)/255; 
[h w]=size(im);

for ih=1:h
    im(ih,radLimits(ih):end,:)=0;
end
    

%-------------Change back to Cartesian coords


h=360;
w=260;
originX=cx;
originY=cy;
newIm=zeros(h,w,3);


angleGap=(2*pi)/n;



polarImageIterator=1;

initAngle=pi/2;

for line=0:n-1
    line
    angle=initAngle+line*angleGap;
    vecx=cos(angle);
    vecy=sin(angle);
    vec=[vecx vecy];
    vNorm=norm(vec);
    vec=vec/vNorm;
    
    x=originX;
    y=originY;
    cv=[x y];
    pos=cv;
    vec;
    for i=1:lineLength
        % Matlab image space has an inverted
        %Y axis compared to trig space
        pos=pos+vec;
        rPos=round(pos);
        if 0 < rPos(1) && rPos(1) < w && 0 < rPos(2) && rPos(2) < h
            %polarImage(polarImageIterator,i,:)=im(h-rPos(2),rPos(1),:);%Remember to complement the Y coord!!
            newIm(h-rPos(2),w-rPos(1),:)=im(polarImageIterator,i,:);
            
            %im(h-rPos(2),rPos(1),:)=255; %Remember to complement the Y coord!!
             
        end
    end
    polarImageIterator=polarImageIterator+1;
end

imshow(newIm);