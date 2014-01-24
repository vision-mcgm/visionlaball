function [ ok,tFin ] = task_ovalAndResize_group(c,frameNames,faceDimensions,facePositions )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
tStart=tic;
h=c.h;
w=c.w

for i=size(frameNames,1)
    
    fileName=[rightPath(c,c.dirBitmapsBeforeResize) frameNames(i).name];
    %dbgLog(fileName);
    frame=imread(fileName);
    
    
    
    %NewIm = imresize(frame, [h w]);
    faceCentreX=facePositions(i,1)+faceDimensions.dx;
    faceCentreY=facePositions(i,2)+faceDimensions.dy;
    maskedFrame=wipeOval(frame,faceCentreX,faceCentreY,faceDimensions.ex,faceDimensions.ey);
    
    
    
    if faceDimensions.ey < faceDimensions.ex
        xBigger=1;
    else
        xBigger=0;
        %This is normal for face images
        newX=faceDimensions.ey*0.833333;
        newRadiusX=round(newX);
        newRadiusY=faceDimensions.ey;
        rightAspectRatioIm=maskedFrame(faceCentreY-newRadiusY:faceCentreY+newRadiusY,...
            faceCentreX-newRadiusX:faceCentreX+newRadiusX,:);
    end
    
    outIm = imresize(rightAspectRatioIm, [h w]);
    
    outPath= [rightPath(c,c.dirSourceBitmaps) frameNames(i).name];
    
    imwrite(outIm,outPath,'bmp');
end
ok=1;
tFin=toc(tStart);
end

