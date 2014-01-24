%function [  ] = getWarps( f,ref )
%Gets warps for a folder and puts them in a "warp" subfolder

%NO PRERUNS

global local;
local=0;

name='atkinson';
f.l=['W:\Fintan\Data\motion\processed\' name '\'];
f.r=['\\komodo\SharedData\Fintan\Data\motion\processed\' name '\'];

maxWorkers=120;

list=dir([f.l '*.bmp']);

l=size(list,1);

for i=1:l-1 %As we are doing comparisons, we must count edges not vertices
    
         frameFiles(i).name=[s(f) list(i+1).name];
    
   % frameFiles(i).name=[s(f) list(i+1).name];
   
   refImages(i).name=[s(f) list(i).name];
    
end

im=imread([f.l list(i+1).name]);
[h w c]=size(im);

refF=importdata([f.l 'ref.txt']);
refF=refF{1}; %To remove from cell

%refF=myLoad.refF;

refImage=[s(f) refF];

dirFlowFields.r =[f.r 'warp\'];
dirFlowFields.l=[f.l 'warp\'];

checkDir(dirFlowFields.l);

nOps=size(frameFiles,2);
opsPerTask = ceil(nOps/maxWorkers);
job=prepareJob_noconf();

lastOpCompleted=0;
for i=1:nOps
    fprintf('Creating task %i of %i.\n',i,nOps);
    firstOp=(i-1)*opsPerTask +1;
    finalOp=min(i*opsPerTask,nOps);
    frameFilesSlice = frameFiles(firstOp:finalOp);
    refImageSlice=refImages(firstOp:finalOp);
    if lastOpCompleted < nOps
        if local
            task_warp_incr_group_util_mod(h,w,frameFilesSlice,refImageSlice,dirFlowFields.l,firstOp:finalOp);
        else
        tasks{i}=createTask(job,@task_warp_incr_group_util_mod,2,...
            {h,w,frameFilesSlice,refImageSlice,dirFlowFields.r,firstOp:finalOp});
        end
    end
    lastOpCompleted=finalOp;
end

submit(job);
jobMonitor(job);
destroy(job);

1
%end

