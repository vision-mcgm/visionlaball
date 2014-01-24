function [  ] = altixBatchmcgm(  )
%Batch process MCGMs
%FSN 2013

%Parameters
maxWorkers=100;
f='W:\Fintan\Experiments\frames\normal\';
fOut='W:\Fintan\Data\fireMCGMs';
ext='bmp';

% Initial set up.
f=checkSlash(f);
fOut=checkSlash(fOut);
checkDir(fOut);
disp('Calculating mcgm');

nOutArgs=2;

local=0; %Toggle local processing


%Job setup
sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
job=createJob(sched);
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);

replicatedClusterRoot='C:\Export\JobData1\VisionLabLibrary\';
clusterRoot='\\komodo\SharedData\Fintan\';

%Path dependencies from altixDiag
paths={replicatedClusterRoot,[replicatedClusterRoot 'Code\matlab-helpers\'],[replicatedClusterRoot 'Code\'],...
   [replicatedClusterRoot 'Code\sharePipe'],...
   ['C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev\'],...
   [replicatedClusterRoot 'Code\sockets'],...
   [replicatedClusterRoot 'Code\mcgm'],...
   [replicatedClusterRoot 'Code\motionTransfer'],...
   [replicatedClusterRoot 'Code\common'],...
   [replicatedClusterRoot 'Code\altixBatchmcgm'],...
    [clusterRoot 'tests\mexfiles']};		% UNC paths to any other folders needed by the workers to execute their tasks.


l=dir([f '*.' ext]);
n=size(l,1);

for i=1:n-1
    argStruct(i,1).ref=loc2Rem([f l(i).name]);
   argStruct(i,1).target=loc2Rem([f l(i+1).name]);
   argStruct(i,1).out=loc2Rem([fOut num2str(i,'%04d') '.mat']);
end

sliceAndSend(@task_mcgm_group,paths,argStruct);
    


end

