%Gets keypoints from images

%Parameters:
playEyeGaze_params %Set params

%Start code

checkDir(out);

l=dir([in '*.JPG']);

n=size(l,1);

for i=1:n
    im=imread([in l(i).name]);
    imshow(im);
    [xs ys]=ginput()
    allXs(i,:)=xs;
    allYs(i,:)=ys;
end

save([in 'kpts.mat'],'allYs','allXs');


