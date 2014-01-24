function [ ok,tFin ] = task_resize(c,frameNo,frameName,faceDimensions,facePositions )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
tStart=tic;
h=c.h;
w=c.w

fileName=[remPath(c,c.dirBitmapsBeforeResize) frameName];
%dbgLog(fileName);
frame=imread(fileName);

dimFile=[rightPath(c,c.dirPCAModel) 'all\faceDimensions'];
posFile=[rightPath(c,c.dirPCAModel) 'all\facePositions'];

%NewIm = imresize(frame, [h w]);
faceCentreX=facePositions(frameNo,1)+faceDimensions.dx;
faceCentreY=facePositions(frameNo,2)+faceDimensions.dy;
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

outPath= [remPath(c,c.dirSourceBitmaps) frameName];

imwrite(outIm,outPath,'bmp');
ok=1;
tFin=toc(tStart);
end

