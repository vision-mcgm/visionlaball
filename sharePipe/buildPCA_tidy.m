function [  ] = buildPCA( c )
%Build PCA morph model
%FSN from ideas by Glyn and Fatos
%Written 2012, rewrite Jun 13


% Parameters

maxWorkers=120; %Num of workers to use
local=0; %Toggle local processing

allStartTime=tic; %Start tim
h=c.h;
w=c.w;
%Static params
nWarpOutArgs=2; %Num of outpur arguments from warp process
success=false;
%Code
disp('Building PCA...');

%Setup paths
clusterRoot=c.replicatedClusterRoot;					% The UNC path to the shared folder on the cluster head node.
localRoot=c.localRoot;								% The mapped drive and path to the clusterRoot folder, as mounted on the client.
dirPCAModel=c.dirPCAModel;
dirPCAModelREM=remPath(c,c.dirPCAModel);% Results data output location.
dirSourceBitmaps=remPath(c,c.dirSourceBitmaps);			% THIS IS A REMOTE PATH!! DO NOT USE FOR LOCAL ACCESS!

%Check for missing frames field and fill in
if isfield(c,'frames')
    frames=c.frames;
else
    frameList=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);
    frames=size(frameList,1);
    c.frames=frames;
end
PCs=c.PCs;


%Job setup
cd(localRoot);											% Change into the working dir on the client.
sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
job=createJob(sched);
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);


%Path dependencies
paths={c.replicatedClusterRoot,[c.replicatedClusterRoot 'Code\matlab-helpers\'],[c.replicatedClusterRoot 'Code\'],...
    [c.replicatedClusterRoot 'Code\sharePipe'],...
    ['C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev\'],...
    [c.replicatedClusterRoot 'Code\sockets'],...
    [c.replicatedClusterRoot 'Code\mcgm'],...
    [c.replicatedClusterRoot 'Code\motionTransfer'],...
    [c.replicatedClusterRoot 'Code\common'],...
    [clusterRoot 'tests\mexfiles']};
set(job,'PathDependencies',paths);

%Check folders
PCADir=[rightPath(c,c.dirPCAModel)];
warpDir=[PCADir 'warp'];
allDir=[PCADir 'all'];
morphDir=[PCADir 'morph'];
checkDir(PCADir);
checkDir(warpDir);
checkDir(allDir);
%Save config file
save([allDir '/config.mat'],'c');

frameNames=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);
% Read the list of image names from the client's local mounted drive: 'Test2\mitch_ready\*.bmp');
refImage=[dirSourceBitmaps c.referenceFrameFiles{1}];
cprintf('Red','Reference image is %s.\n', refImage);
dirFlowFields=[remPath(c,c.dirPCAModel) 'warp\'];
fprintf('Adding warp task for %i frames %d...',frames);

%TASK 1: WARP

%Find number of operations
opsPerTask = ceil(frames/maxWorkers);
ops=frames;

lastOpCompleted=0;
%Loop over tasks
for i=1:maxWorkers
    firstOp=(i-1)*opsPerTask +1;
    finalOp=min(i*opsPerTask,ops);
    
    %Make the slice of frame names
    frameNamesSlice = frameNames(firstOp:finalOp);
    for temp_it=1:size(frameNamesSlice,1)
        %frameFileSlice(temp_it).name = rem2Loc(c,[dirSourceBitmaps frameNamesSlice(temp_it).name]);
        frameFileSlice(temp_it).name = [dirSourceBitmaps frameNamesSlice(temp_it).name];
    end
    if lastOpCompleted < ops
        if not(local)
            fprintf('Adding warp task for opgroup %d...\n',i);	% Debug.
            tasks_2{i}=createTask(job,@task_warp_group,nWarpOutArgs,...
                {c,frameFileSlice,refImage,dirFlowFields,firstOp:finalOp});
        else
            fprintf('Doing warp task for opgroup %d...\n',i);
            task_warp_group(c,frameFileSlice,refImage,dirFlowFields,firstOp:finalOp);
        end
    end
    lastOpCompleted=finalOp;
end

if not(local)
    tic;									% Start a timer.
    submit(job);
    fprintf('\nJob 1 - Warp tasks submitted. Running...\n');
    %waitForState(job);
    jobMonitor(job);
    tasks_2{1}
    fprintf('Job 1 ended with state %s after %6.4f seconds.\n',job.state,toc);
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    %celldisp(allresults);						% Debug. Display all the times and status values.
    
    % Check for errors.
    errmsgs=get(job.Tasks,{'ErrorMessage'});			% Return the error results from each task as an array.
    nonempty=~cellfun(@isempty,errmsgs);				% Check whether error array is non-empty.
    celldisp(errmsgs(nonempty));						% Display any non-empty error messages of tasks in the job object.
end
% Check for success.
success=true;

% times(:)=allresults{:}{2};
times(1)=1;

%----------Job 2 - (tasks_3) - Calculate mean flow field.
if success
    fprintf('Warps took min %6.4f, max %6.4f, mean %6.4f secs.\n',min(times),max(times),mean(times));
    
    
    fprintf('Job 2 - Adding get-mean-flow, tasks_3...\n');
    
    %Job setup
    sched=findResource();							% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    cd(localRoot);						% should already be in the working dir, from the last job. % Change into the working dir on the client.
    set(job,'PathDependencies',paths);			% paths should already be defined.
    
    MeanFFieldFile=[remPath(c,c.dirPCAModel) 'all\MeanWarp.mat'];
    thiswarpDir=[remPath(c,c.dirPCAModel) 'warp'];
    thisallDir=[remPath(c,c.dirPCAModel) 'all'];
    % This task runs on just one worker, but needs all the files created by the previous task, before it can start.
    tasks_3{1}=createTask(job,@task_getMeanFlow,nWarpOutArgs,{MeanFFieldFile,c});
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
    tasks_3{1}
    fprintf('Job 2 - Get-mean-flow job ended with state %s after %6.4f seconds.\n',job.state,toc);
    
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    %celldisp(allresults);						% Debug.
    if(~checkSuccess(tasks_3,allresults,2));
        fprintf('Job 2 had errors.\n');
    else
        fprintf('Job 2 completed OK.\n');			% debug.
        
        
        
    end
end

    %---------Job 3 - (tasks_4) - Calculate morph vectors relative to the mean
if success
    

    %Job setup
    sched=findResource();						% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    cd(localRoot);								% Change into the working dir on the client.
    set(job,'PathDependencies',paths);
    fprintf('Job 3 - Adding mean-rel-morph-vector task for %d frames.',frames);
    for i=1:frames
        fprintf('Job 3 - Adding mean-rel-morph-vector task for frame %d...\n',i);	% Debug.
        thisFramePath=[dirSourceBitmaps frameNames(i).name];
        MeanFFieldFile=[remPath(c,c.dirPCAModel) 'all\MeanWarp.mat'];
        thiswarpDir=[remPath(c,c.dirPCAModel) 'warp\'];
        thismorphDir=[remPath(c,c.dirPCAModel) 'morph\'];
        tasks_4{i}=createTask(job,@task_getMorph,nWarpOutArgs,{thisFramePath,MeanFFieldFile,i,frames,thiswarpDir,thismorphDir});
    end
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
    tasks_4{1}
    fprintf('\nJob 3 - mean-rel-morph-vector job ended with state %s after %6.4f seconds.\n',job.state,toc);
    
    % Retrieve the output arguments.
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    %celldisp(allresults);				% Debug.
    
    % Check for errors.
    errmsgs=get(job.Tasks,{'ErrorMessage'});	% Return the error results from each task as an array.
    nonempty=~cellfun(@isempty,errmsgs);		% Check whether error array is non-empty.
    celldisp(errmsgs(nonempty));				% Display any non-empty error messages of tasks in the job object.
    
    
end
% Check for success.
success=true;
for i=1:frames
    if allresults{i}{1}~=1					% ~cellfun(@(x) x(~=1),allresults{,1})
        success=false;
    end
    times(i)=allresults{i}{2};
end



if success
    %----------------Job 4 - (tasks_5) - Collect morph vectors and store them in a single variable
    fprintf('Job 4 - Collecting morph vectors...\n');
    
    %Job setup
    sched=findResource();					% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    cd(localRoot);							% Change into the working dir on the client.
    set(job,'PathDependencies',paths);
    thisallDir=[remPath(c,c.dirPCAModel) 'all\'];
    thismorphDir=[remPath(c,c.dirPCAModel) 'morph\'];
    tasks_5{1}=createTask(job,@task_collectMorphVectors,nWarpOutArgs,{c,thismorphDir,thisallDir});
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
    tasks_5{1}
    fprintf('Job 4 - Collect-morph-vector job ended with state %s after %6.4f seconds.\n',job.state,toc);
    
    % Retrieve the output arguments.
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    %celldisp(allresults);					% Debug.
    if(~checkSuccess(tasks_5,allresults,4));
        fprintf('Job 4 had errors.\n');
    else
        fprintf('Job 4 finished OK.\n');		% Debug.
    end
    
end

if success
    
    %-------------Job 5 - (tasks_6) - Train PCA model, calculate loadings and variance
    fprintf('Job 5 - Performing PCA...\n');
    
    %Job setup
    sched=findResource();				% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    cd(localRoot);						% Change into the working dir on the client.
    set(job,'PathDependencies',paths);
    thisallDir=[remPath(c,c.dirPCAModel) 'all\'];
    if 1 %Switch to local
        tasks_6{1}=createTask(job,@task_PCA,nWarpOutArgs,{c});
    else
        task_PCA(c);
    end
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
    tasks_6{1}
    fprintf('Job 5 - PCA job ended with state %s after %6.4f seconds.\n',job.state,toc);
    
    % Retrieve the output arguments.
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    %celldisp(allresults);					% Debug.
    if(~checkSuccess(tasks_6,allresults,5));
        fprintf('Job 5 had errors.\n');
    else
        fprintf('Job 5 completed OK.\n');
        %tt=etime(clock,allStartTime);
        tt=toc(allStartTime);
        fprintf('All the jobs have been run successfully.\n\nTotal time take was %10.6f secs.\n',tt);
    end									% End of else block from tasks_6.
    % End of else block from tasks_3.
    
end
end													% End of else block from tasks_2.
destroy(job);
%clear tasks_6;
%clear job;


end

