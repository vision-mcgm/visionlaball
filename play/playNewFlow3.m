%Requires playNewFlow1 to be run first
%Requires an image called grid to warp

%Applies the warps SEQUENTIALLY

%grid=double(grid/255);

grid=imread('W:\Fintan\Data\motion\atkinsonRef.bmp');
grid=double(grid);
grid=(grid/255);
im=grid;
[h w]=size(warps(i).TWx);
thisX=zeros(h,w);
thisY=zeros(h,w);
for i=1:l
    
    %[Px,Py]=vector2PixelPos(warps(i).TWx,warps(i).TWy);
    thisX=thisX+warps(i).TWx;
    thisY=thisY+warps(i).TWy;

    [Px,Py]=vector2PixelPos(thisX,thisY);
    
    im=rgbinterp2_lone(grid,Px,Py);
 %im=  interp2(grid,Px,Py);
    imshow(im)
    pause(0.04)
end

