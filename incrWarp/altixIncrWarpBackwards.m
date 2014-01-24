function [  ] = altixIncrWarp( f )
%Takes a folder and uses the cluster to incrementally warp everything in it

f='W:\Fintan\Experiments\frames\normal'

%Params
ext='bmp';

%Setup
f=checkSlash(f);
of=[f 'BackwardsWarpOutput\'];
checkDir(of);


l=dir([f '*.' ext]);
n=size(l,1);


%Prep paths- make full paths

for i=0:n-2
    %Must be colvecs
    ib=n-i;
    i1=i+1;
    args(i1,1).source=loc2Rem([f l(ib).name]);
    args(i1,1).target=loc2Rem([f l(ib-1).name]);
    args(i1,1).output=loc2Rem([of 'warp' num2str(i+1,'%04d') '.mat']);
end

%task_incrMCGMGroup(1,1,l1,l2,of);
sliceAndSend(@task_incrMCGMGroup,args);


end

