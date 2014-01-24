function [  ] = buildJPCA( c )
%Construct Vision Lab morph space model from configuration file

%Parameters
local=0; %Toggle local processing

% Initial set up.
disp('Building PCA...');
maxWorkers=100;
nWarpOutArgs=2;
allStartTime=tic;
h=c.h;
w=c.w;

%Work

clusterRoot=c.replicatedClusterRoot;					% The UNC path to the shared folder on the cluster head node.
localRoot=c.localRoot;								% The mapped drive and path to the clusterRoot folder, as mounted on the client.
dirPCAModel=c.dirPCAModel;
dirPCAModelREM=remPath(c,c.dirPCAModel);% Results data output location.
dirSourceBitmaps=remPath(c,c.dirSourceBitmaps);			% THIS IS A REMOTE PATH!! DO NOT USE FOR LOCAL ACCESS!
if isfield(c,'frames')
    frames=c.frames;
else
    frameList=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);
    frames=size(frameList,1);
    c.frames=frames;
end
PCs=c.PCs;


%Job setup
cd(localRoot);                                            % Change into the working dir on the client.
%setting cluster with name sched
sched=findResource();                                   % sched=findResource('scheduler','configuration','jobmanagerconfig0');
%creating the job on cluster sched
job=createJob(sched);

set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);
%REMEMBER THAT THIS IS BEING SET FROM THE REPLICATED CLUSTER ROOT - replicatedClusterRoot=C:\Export\JobData1\VisionLabLibrary\

paths=altixPaths;
set(job,'PathDependencies',paths);
PCADir=[rightPath(c,c.dirPCAModel)];
warpDir=[PCADir 'warp'];	
allDir=[PCADir 'all']; 	
morphDir=[PCADir 'morph'];	
%Check existence of directories
checkDir(PCADir);
checkDir(warpDir);
checkDir(allDir);
checkDir(morphDir);

save([allDir '/config.mat'],'c');

frameNames=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);
% Read the list of image names from the client's local mounted drive: 'Test2\mitch_ready\*.bmp');
refImage=[dirSourceBitmaps c.referenceFrameFiles{1}];
cprintf('Red','Reference image is %s.\n', refImage);
dirFlowFields=[remPath(c,c.dirPCAModel) 'warp\'];


%----------------------JOB 1: WARPS


fprintf('Adding warp task for %i frames %d...',frames);
opsPerTask = ceil(frames/maxWorkers);
ops=frames;

lastOpCompleted=0;
for i=1:maxWorkers   
    firstOp=(i-1)*opsPerTask +1;
    finalOp=min(i*opsPerTask,ops);
    
    %Make the slice of frame names
    frameNamesSlice = frameNames(firstOp:finalOp);
    for temp_it=1:size(frameNamesSlice,1)
        frameFileSlice(temp_it).name = [dirSourceBitmaps frameNamesSlice(temp_it).name];
    end
    if lastOpCompleted < ops        
        if not(local)
            fprintf('Adding warp task for opgroup %d...\n',i);	% Debug.
            tasks_2{i}=createTask(job,@task_warp_group,nWarpOutArgs,...
                {c,frameFileSlice,refImage,dirFlowFields,firstOp:finalOp,i});
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
success=true;
times(1)=1;


%----------------------JOB 2: FIND MEAN FLOW



if ~success
    statusMsg('1','NOT','Warps');
else
    statusMsg('1','','Warps');
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
    
end% Debug.


%----------------------JOB 3: CALCULATE MEAN RELATIVE MORPH VECTORS

if(~checkSuccess(tasks_3,allresults,2));
    fprintf('Job 2 had errors.\n');
else
    fprintf('Job 2 completed OK.\n');			% debug.
    
    %Job setup
    sched=findResource();						
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
    
    % Check for errors.
    errmsgs=get(job.Tasks,{'ErrorMessage'});	% Return the error results from each task as an array.
    nonempty=~cellfun(@isempty,errmsgs);		% Check whether error array is non-empty.
    celldisp(errmsgs(nonempty));				% Display any non-empty error messages of tasks in the job object.
    
    % Check for success.
    success=true;
    for i=1:frames
        if allresults{i}{1}~=1
            success=false;
        end
        times(i)=allresults{i}{2};
    end
   
end


%----------------------JOB 4: COLLECT MORPH VECTORS



if ~success
    fprintf('Job 3 - Morphs NOT all successful!\n');
else
    fprintf('Job 3 - Morphs all successful in tasks_4.\n');
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
end


%----------------------JOB 5: DO PCA




if(~checkSuccess(tasks_5,allresults,4));
    fprintf('Job 4 had errors.\n');
else
    fprintf('Job 4 finished OK.\n');		% Debug.
    
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
        tasks_6{1}=createTask(job,@task_JPCA,nWarpOutArgs,{c});
    else
        task_JPCA(c);
    end
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
    tasks_6{1}
    fprintf('Job 5 - PCA job ended with state %s after %6.4f seconds.\n',job.state,toc);
    
    % Retrieve the output arguments.
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    if(~checkSuccess(tasks_6,allresults,5));
        fprintf('Job 5 had errors.\n');
    else
        fprintf('Job 5 completed OK.\n');
        tt=toc(allStartTime);
        fprintf('All the jobs have been run successfully.\n\nTotal time take was %10.6f secs.\n',tt);
    end									
end										

destroy(job);


end

