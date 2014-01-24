
function [ pass ] = test1(  )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

pass=0;

dirInput= 'W:\Fintan\Data\testing\input_1\';

ref=22;

d=dir([dirInput '*.bmp']);
c=struct2cell(d);
names=c(1,:);
names=names';
F=size(names,1);

F=22;

[h w c]=size(imread([dirInput names{1}]));
images=zeros(F,h,w,c);

for f=1:F
    names{f,1}=[dirInput names{f,1}];
   
        
    images(f,:,:,:)=imread(names{f});
end



ref_f=names{ref};

TVx=zeros(F,h,w);
TVy=zeros(F,h,w);

for f=1:F
    disp(f)
    [x y]=warp_util_file(names{f},ref_f);
    
    TVx(f,:,:)=x;
    TVy(f,:,:)=y;
    
    figure(1);
    
   % picflow(squeeze(images(f,:,:,:)),x, y,2));
end

[TMx,TMy, rTMx, rTMy]=getMeanFlow_util_data(TVx,TVy);

[TMx,TMy,T_img,Mx,My,Mtex]=getMorphVectors_util_data(TVx,TVy,images,rTMx,rTMy);

end




