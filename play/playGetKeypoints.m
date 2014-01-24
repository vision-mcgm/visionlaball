%Fintan Nagle, UCL Vision Lab
%Oct 2012


%Instructions:
%Put all images to be aligned in one folder
%Set target folder and extension below
%Hit run
%For each image displayed, click on the centroids of the eyes (not the
%pupils as they may be looking left or right). Click on the person's right
%eye (to your left) first, then their left eye (to your right). After you
%have clicked on both eyes, hit Return. The next image will be displayed.
%When the script has finished the folder will contain a .mat file called
%savedKeypoints.mat. This contains the eye coords.
%Zip up the whole folder and send it over; I'll align the images.

%Parameters
folder='C:\Users\PaLS\Desktop\fintan\VisualStudio\TestAppConsole C++_copy(working)\data\armstrong\'; %Set this to the folder the images are located in, with trailing slash
extension='.bmp'; %Set this to extension of images, with preceding dot

%Code

list=dir([folder '*' extension]);
num=size(list,1);

for i=1:num
   thisIm=[folder list(i).name];
   im=imread(thisIm);
   imshow(im);
   coords{i}=ginput;
   names{i}=thisIm;
end

save([folder 'savedKeypoints.mat'],'coords','names');