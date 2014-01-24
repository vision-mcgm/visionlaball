function [  ] = buildPCA( c )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Config as per mitch.pca on 5/2/12.
% doPCA_b1.m Version using shares, without debug code. Nico 8/2/12.

% Initial set up.

local=1; %Local or cluster

disp('Building PCA...');
maxWorkers=100;
nWarpOutArgs=2;

allStartTime=tic;
h=c.h;
w=c.w;

clusterRoot=c.replicatedClusterRoot;					% The UNC path to the shared folder on the cluster head node.
localRoot=c.localRoot;								% The mapped drive and path to the clusterRoot folder, as mounted on the client.
dirPCAModel=c.dirPCAModel;
dirPCAModelREM=remPath(c,c.dirPCAModel);% Results data output location.
dirSourceBitmaps=remPath(c,c.dirSourceBitmaps);			% THIS IS A REMOTE PATH!! DO NOT USE FOR LOCAL ACCESS!

%referenceFrames=c.referenceFrames;

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
sched=findResource();

%REMEMBER THAT THIS IS BEING SET FROM THE REPLICATED CLUSTER ROOT - replicatedClusterRoot=C:\Export\JobData1\VisionLabLibrary\
paths={clusterRoot,[clusterRoot 'Test2'],[clusterRoot 'Code\matlab-helpers'],[clusterRoot 'Code\sharePipe'],...
    [clusterRoot 'Code\common'],...
    [clusterRoot 'Code\mcgm']  };
 %Temp switchoff
if not(local)% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    % UNC paths to any other folders needed by the workers to execute their tasks.
    set(job,'PathDependencies',paths);
    
end

% As the client's mounted drive is a share from the head node of the cluster's replicated file system, any sub-folders and files only need to be created once on the client, to then be available to the task, on all the workers.
PCADir=[rightPath(c,c.dirPCAModel)];									% Defines 'Test2\mitchPCAc\' for use on the workers.
if ~isdir(PCADir);										% Create the PCADir folder on the local mounted drive (called mitchPCAc) if it does not exist.
    mkdir(PCADir);
end
warpDir=[PCADir 'warp'];								% Defines 'Test1\mitchPCAc\warp';
if ~isdir([PCADir 'warp'])    							% Create the warp folder (called warp, below mitchPCA) if it does not exist.
    mkdir([PCADir 'warp']);
end
allDir=[PCADir 'all']; 									% Defines 'Test2\mitchPCAc\all';
if ~isdir([PCADir 'all'])
    mkdir([PCADir 'all']);
end
morphDir=[PCADir 'morph'];								% Defines 'Test2\mitchPCAc\morph';
if ~isdir([PCADir 'morph'])
    mkdir([PCADir 'morph']);
end

% Job 1 - (tasks_2) - Warp all the images.
% if c.recursiveBitmapScan
%     topDir=rightPath(c,c.dirSourceBitmaps);
%    folders=dir(topDir);
%    frameNames={};
%    for i=1:size(folders,1)
%        if folders(i).isdir
%            frameNames=[frameNames;dir([topDir folders(i).name

save([allDir '/config.mat'],'c');

frameNames=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);
% Read the list of image names from the client's local mounted drive: 'Test2\mitch_ready\*.bmp');
refImage=[dirSourceBitmaps c.referenceFrameFiles{1}];
cprintf('Red','Reference image is %s.\n', refImage);
dirFlowFields=[remPath(c,c.dirPCAModel) 'warp\'];
fprintf('Adding warp task for %i frames %d...',frames);

opsPerTask = ceil(frames/maxWorkers);
ops=frames;


if 1 %Temp switchoff
if not(local)
    
    lastOpCompleted=0;
    for i=1:maxWorkers
        
        
        firstOp=(i-1)*opsPerTask +1;
        finalOp=min(i*opsPerTask,ops);
        
        %Make the slice of frame names
        frameNamesSlice = frameNames(firstOp:finalOp);
        for temp_it=1:size(frameNamesSlice,1)
            %frameFileSlice(temp_it).name = rem2Loc(c,[dirSourceBitmaps frameNamesSlice(temp_it).name]);
            frameFileSlice(temp_it).name = [dirSourceBitmaps frameNamesSlice(temp_it).name];
        end
        %refImage=rem2Loc(c,refImage);
        % dirFlowFields=rem2Loc(c,dirFlowFields);
        if lastOpCompleted < ops
            fprintf('Adding warp task for opgroup %d...\n',i);	% Debug.
            tasks_2{i}=createTask(job,@task_warp_group,nWarpOutArgs,...
                {c,frameFileSlice,refImage,dirFlowFields,firstOp:finalOp});
        end
        
        lastOpCompleted=finalOp;
    end
    tic;									% Start a timer.
    submit(job);
    fprintf('\nJob 1 - Warp tasks submitted. Running...\n');
    %waitForState(job);
    jobMonitor(job);
    tasks_2{1}
    fprintf('Job 1 ended with state %s after %6.4f seconds.\n',job.state,toc);
    alltasks=get(job,'Tasks');
    allresults=get(alltasks,'OutputArguments');
    
    errmsgs=get(job.Tasks,{'ErrorMessage'});			% Return the error results from each task as an array.
nonempty=~cellfun(@isempty,errmsgs);				% Check whether error array is non-empty.
celldisp(errmsgs(nonempty));	
    
else
    %------JOB 1 (WARP) LOCAL VERSION
    
    lastOpCompleted=0;
    for i=1:maxWorkers
        
        fprintf('Calling warp tasks %i of %i...\n',i,maxWorkers);
        
        firstOp=(i-1)*opsPerTask +1;
        finalOp=min(i*opsPerTask,ops);
        
        %Make the slice of frame names
        frameNamesSlice = frameNames(firstOp:finalOp);
        for temp_it=1:size(frameNamesSlice,1)
            %frameFileSlice(temp_it).name = rem2Loc(c,[dirSourceBitmaps frameNamesSlice(temp_it).name]);
            frameFileSlice(temp_it).name = [rem2Loc(c,dirSourceBitmaps) frameNamesSlice(temp_it).name];
        end
        %refImage=rem2Loc(c,refImage);
        % dirFlowFields=rem2Loc(c,dirFlowFields);
        if lastOpCompleted < ops
            fprintf('Adding warp task for opgroup %d...\n',i);	% Debug.
            %tasks_2{i}=createTask(job,@task_warp_group,nWarpOutArgs,...
               % {c,frameFileSlice,refImage,dirFlowFields,firstOp:finalOp});
               task_warp_group_oval(c,frameFileSlice,rem2Loc(c,refImage),rem2Loc(c,dirFlowFields),firstOp:finalOp);
        end
        
        lastOpCompleted=finalOp;
    end
   % tic;									% Start a timer.
    %submit(job);
    
    %waitForState(job);
   
    
    
end
end %End temp switchoff
%celldisp(allresults);						% Debug. Display all the times and status values.

% Check for errors.
					% Display any non-empty error messages of tasks in the job object.

% Check for success.
success=true;

% times(:)=allresults{:}{2};
times(1)=1;

if ~success
    statusMsg('1','NOT','Warps');
else
    statusMsg('1','','Warps');
    fprintf('Warps took min %6.4f, max %6.4f, mean %6.4f secs.\n',min(times),max(times),mean(times));
    
    %----------Job 2 - (tasks_3) - Calculate mean flow field.
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
        
        
        
        
        %---------Job 3 - (tasks_4) - Calculate morph vectors relative to the mean
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
        
        % Check for success.
        success=true;
        for i=1:frames
            if allresults{i}{1}~=1					% ~cellfun(@(x) x(~=1),allresults{,1})
                success=false;
            end
            times(i)=allresults{i}{2};
        end
        if ~success
            fprintf('Job 3 - Morphs NOT all successful!\n');
        else
            fprintf('Job 3 - Morphs all successful in tasks_4.\n');
            %fprintf('Morphs take min %6.4f, max %6.4f, mean %6.4f secs.\n',min(times),max(times),mean(times));
            
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
                tasks_6{1}=createTask(job,@task_PCA,nWarpOutArgs,{c});
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
            end										% End of else block from tasks_5.
        end											% End of else block from tasks_4.
    end												% End of else block from tasks_3.
end													% End of else block from tasks_2.
%destroy(job);
%clear tasks_6;
%clear job;


end

