function [ img ] = hsvInvert(img,channel )
%Complements an HSV image - 1 inverts hue, 2 saturation, 3 channel. Returns
%uint8 images.
img=rgb2hsv(img);
switch channel
    case 1
img(:,:,1)=mod(img(:,:,1)+0.5,1);
    case 2
    case 3
img(:,:,3)=1-img(:,:,3);
end
img=hsv2rgb(img);
img=uint8(img*255);

end

