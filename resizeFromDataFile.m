function [  ] = resizeFromDataFile( c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxWorkers=115;
nOutArgs1=2;

sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
job=createJob(sched);
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);


clusterRoot=c.clusterRoot;
%THIS IS THE IMPORTANT PATH-SETTING PART.
paths={[c.replicatedRoot 'Code\matlab-helpers'],...
    [c.replicatedRoot 'Code']};		% UNC paths to any other folders needed by the workers to execute their tasks.
set(job,'PathDependencies',paths);

outputDir=rightPath(c,c.dirSourceBitmaps);
dirBitmapsBeforeResizeREM=remPath(c,c.dirBitmapsBeforeResize);

if ~isdir(outputDir);										% Create the PCADir folder on the local mounted drive (called mitchPCAc) if it does not exist.
    mkdir(outputDir);
end

frameNames=dir([rightPath(c,c.dirBitmapsBeforeResize) '*.bmp']); 	

dimFile=[rightPath(c,c.dirPCAModel) 'all\faceDimensions.mat'];
load(dimFile);
posFile=[rightPath(c,c.dirPCAModel) 'all\facePositions.mat'];
load(posFile);

opsPerTask=ceil(c.frames/maxWorkers);
ops=size(frameNames,1);

for i=1:maxWorkers
    fprintf('Adding resize task %d...\n',i);	
    thisFramePath=[dirBitmapsBeforeResizeREM frameNames(i).name];
    thisFrameList=frameNames((i-1)*opsPerTask +1 : min(i*opsPerTask,ops));
    tasks_1{i}=createTask(job,@task_ovalAndResize_group,nOutArgs1,...
        {c,thisFrameList,faceDimensions,facePositions});
    
end


submit(job);
jobMonitor(job);
%waitForState(job);

%checkOK(tasks_1);


end

