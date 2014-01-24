%Does motion detection on AVI videos, sequentially pairwise, for Nicholas
%Furl's videos

%Parameters

f='D:\fintanData\furl'; %Input folder
f=checkSlash(f);

mcgmcpp = 1.5;
mcgmconv = 23;
mcgmthresh = 0.1;

%Code

list=dir([f '*.avi']);
n=size(list,1);

outDir='out';
outDir=checkSlash(outDir);
outDir=[f outDir];
checkDir(outDir);

for v=1:n
    ['Reading video ' num2str(v)]
    reader=VideoReader([f list(v).name]);
    
    thisVidFrames=reader.NumberOfFrames;
    
    
    
    for i=1:thisVidFrames
        ['        Reading frame ' num2str(i)]
        
        if i==1
            fa=read(reader,i);
        else
            fb=read(reader,i);
            fa=double(fa)/255;
            fb=double(fb)/255;
            [shot vel angles]=mcgm2(fa, fb, mcgmcpp, mcgmconv, mcgmthresh);
            shot_all(:,:,i)=shot;
            vel_all(:,:,i)=vel;
            angles_all(:,:,i)=angles;
            
            fa=fb;
        end
        
    end
    
    save([f list(v).name '.mat'],'shot_all','vel_all','angles_all');
    clear shot_all
    clear vel_all
    clear angles_all
end
