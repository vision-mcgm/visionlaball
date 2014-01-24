function [  ] = ssimTimeTest(  )
%Tests time of SSIM


p1='W:\Fintan\Experiments\frames\normal\frame00050.bmp';
p2='W:\Fintan\Experiments\frames\normal\frame00250.bmp';

p1=loc2Rem(p1);
p2=loc2Rem(p2);
root=rgb2gray(imread(p1));
target=rgb2gray(imread(p2));
tic;

  indices(1,root,target)=ssim_index(root,target);

    indices(2,root,target)=mean(mean(imabsdiff(root,target)));

    indices(3,root,target)=norm(double(target-root));
time=toc;

end

