function [  ] = altixIncrWarp( f )
%Takes a folder and uses the cluster to incrementally warp everything in it

f='W:\Fintan\Experiments\frames\normal'

%Params
ext='bmp';

%Setup
f=checkSlash(f);
of=[f 'warpOutput\'];
checkDir(of);


l=dir([f '*.' ext]);
n=size(l,1);


%Prep paths- make full paths

for i=1:n-1
    %Must be colvecs
    args(i,1).source=loc2Rem([f l(i).name]);
    args(i,1).target=loc2Rem([f l(i+1).name]);
    args(i,1).output=loc2Rem([of 'warp' num2str(i,'%04d') '.mat']);
end

%task_incrMCGMGroup(1,1,l1,l2,of);
sliceAndSend(@task_incrMCGMGroup,args);


end

