function [  ] = cropAndAlterFolder(  )
%Crops a folder to the requisite rectangle, then applies a couple of
%transformations.
f='D:\fintanData\fireplace\mainDatasetBMPs\32-36mins';
out='D:\fintanData\fireplace\mainDatasetBMPs\cropped_32-36mins';
f=checkSlash(f);
out=checkSlash(out);


rect= [291   38  640  563]; %xmin ymin width height
ext='bmp'; %WARNING if changing this you will need to change the imwrite formats
l=dir([f '*.' ext]);

negOut=[f 'negative\'];
hueOut=[f 'hue\'];
normalOut=[f 'normal\'];

checkDir(negOut);
checkDir(hueOut);
checkDir(normalOut);

n=size(l,1);

for i=1:n
    i
    im=imread([f l(i).name]);
    im=imcrop(im,rect);
  %  imNeg=hsvInvert(im,1);
  %  imHue=hsvInvert(im,3);
    imwrite(im,[out l(i).name],'bmp');
   % imwrite(imNeg,[negOut l(i).name],'bmp');
   % imwrite(imHue,[hueOut l(i).name],'bmp');
    
end

end

