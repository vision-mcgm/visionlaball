%Splits an image up radially into lines
%Conventions of the trig circle
%Radians

im=test;
n=100;
[h w d]=size(im);
lineLength=200;

angleGap=(2*pi)/n;

clear polarImage
polarImage=uint8(zeros(n,lineLength,3));
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
    
    x=cx;
    y=cy;
    cv=[x y];
    pos=cv;
    vec;
    for i=1:lineLength
        % Matlab image space has an inverted
        %Y axis compared to trig space
        pos=pos+vec;
        rPos=round(pos);
        if 0 < rPos(1) && rPos(1) < w && 0 < rPos(2) && rPos(2) < h
            polarImage(polarImageIterator,i,:)=im(h-rPos(2),rPos(1),:);%Remember to complement the Y coord!!
            
            %im(h-rPos(2),rPos(1),:)=255; %Remember to complement the Y coord!!
             
        end
    end
    polarImageIterator=polarImageIterator+1;
end
imshow(im);
imshow(polarImage);