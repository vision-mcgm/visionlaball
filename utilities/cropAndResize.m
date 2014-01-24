%Shows first image in folder, gives you a crop box, then crops and resizes
%all other images to an output folder

%Parameters

h=240;
w=200;
extension='.bmp';

folder='W:\Fintan\Data\nickFurl\identities\f002';

%Code
folder=checkSlash(folder);

list=dir([folder '*' extension]);
n=size(list,1);

im1=imread([folder list(1).name]);

%[i2 rect]=imcrop(im1);

outFolder=[folder 'cropped'];
outFolder=checkSlash(outFolder);
checkDir(outFolder);

for i=1:n
    i
    imPath=[folder list(i).name];
    im1=imread(imPath);
  %  im2=imcrop(im1,rect);
  im2=imresize(im1,0.3);
    imwrite(im2,[outFolder 'frame' num2str(i) '.bmp'],'bmp');
end



