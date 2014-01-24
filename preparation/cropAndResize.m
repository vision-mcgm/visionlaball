%Resizes images to a specified size and crops them according to a placed
%box
%The HORIZONTAL side of the box is taken, the vertical side is computed
%from the given aspect ratio.

%Params

h=120;
w=213;

dIn='W:\Fintan\Data\flame\pool\subset1\';
%dOut='W:\Fintan\Data\flame\3cropped\';
dOut=[dIn 'resized\'];
checkDir(dOut);

ext='bmp';
resize=0; %This controls whether to resize the images, or just crop them.
adjustVerticalToAspectRatio=0;

%Code

hOverW=h/w;

l=dir([dIn '*.' ext]);
n=size(l,1);

for i=1:n
    i
    if i==1
        im=imread([dIn l(i).name]);
        [i2 rect]=imcrop(im);
        w=rect(3);
        h=w*hOverW;
        if adjustVerticalToAspectRatio
        newRect=[rect(1) rect(2) w h];
        else
            newRect=rect;
        end
        
    end
    
    im=imread([dIn l(i).name]);
    im2=imcrop(im,newRect);
    if resize, im2=imresize(im2,[h w]);, end
    imwrite(im2,[dOut l(i).name]);
    
    end
        