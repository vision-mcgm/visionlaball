%Requires playNewFlow1 to be run first
%Requires an image called grid to warp

%grid=double(grid/255);

grid=imread('W:\Fintan\Data\motion\shatnerRef.bmp');
grid=double(grid);
grid=(grid/255);
for i=1:l
    
    [Px,Py]=vector2PixelPos(warps(i).TWx,warps(i).TWy);

    im=rgbinterp2_lone(grid,Px,Py);
 %im=  interp2(grid,Px,Py);
    imshow(im)
    pause(0.04)
end

