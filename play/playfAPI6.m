%This is just the last bit of the process - first bit sneeds to be run
%first

%This just crops - masking is already done



xWindow=190;
yWindow=xWindow*1.2;

xRadius=xWindow/2;
yRadius=yWindow/2;

for i=firstValidIm:min(validCoords,limit)
    i
    thisIm=imStack{i};
    %cropped=thisIm(yNewMin:yNewMax,xNewMin:xNewMax,:);
    %cropped=thisIm(yMin:yMax,xMin:xMax,:);
    %cropped=thisIm(round(cY-yExtent):round(cY+yExtent),round(cX-xExtent):round(cX+xExtent),:);
    %resized=imresize(cropped, [240 200]);
    %resized=thisIm;
    %i2=wipeOval(thisIm,centreX,centreY,xRadius,yRadius);
   % 
  % i2=fadeOutFrame(thisIm,squeeze(maskY(i,:)'),squeeze(maskX(i,:))');
   i3=thisIm(centreY-yRadius:centreY+yRadius,centreX-xRadius:centreX+xRadius,:); %Adjustments to get 200*240 images
    i4=imresize(i3, [120 100]);
    imwrite(i4,[outFolder 'frame' num2str(i,'%03d') '.bmp'],'bmp');
    imshow(i3);
end