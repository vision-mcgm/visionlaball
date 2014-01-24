% Config as per mitch.pca on 5/2/12.
% doPCA_b1.m Version using shares, without debug code. Nico 8/2/12.

% Initial set up.
allStartTime=tic;
h=120;
w=100;

clusterRoot='\\komodo\SharedData\Fintan\';						% The UNC path to the shared folder on the cluster head node.
localRoot='W:\Fintan';									% The mapped drive and path to the clusterRoot folder, as mounted on the client.
dirPCAModel=[clusterRoot 'Test2\mitchPCAr\'];						% Results data output location.
dirSourceBitmaps=[clusterRoot 'Test2\mitch_ready\'];					% DataOnly\fintan changed to Test2.

referenceFrames=58;
frames=209;
PCs=50;
maxWorkers=100;
nWarpOutArgs=2;

%Job setup
cd(localRoot);											% Change into the working dir on the client.
sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
job=createJob(sched);
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);

paths={clusterRoot,[clusterRoot 'Test2'],[clusterRoot 'Test1\peng-legacy'],[clusterRoot 'Test1\matlab_helpers']};		% UNC paths to any other folders needed by the workers to execute their tasks.
set(job,'PathDependencies',paths);

% As the client's mounted drive is a share from the head node of the cluster's replicated file system, any sub-folders and files only need to be created once on the client, to then be available to the task, on all the workers.
PCADir=[dirPCAModel];									% Defines 'Test2\mitchPCAc\' for use on the workers.
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
frameNames=dir([dirSourceBitmaps '*.bmp']); 		% Read the list of image names from the client's local mounted drive: 'Test2\mitch_ready\*.bmp');
refImage=[dirSourceBitmaps frameNames(referenceFrames).name];
dirFlowFields=[warpDir '\'];
fprintf('Adding warp task for %i frames %d...',frames);
for i=1:frames
    %fprintf('Adding warp task for frame %d...\n',i);	% Debug.
    thisFramePath=[dirSourceBitmaps frameNames(i).name];	% The path is relative to the cluster root folder.
    tasks_2{i}=createTask(job,@task_warp,nWarpOutArgs,{thisFramePath,refImage,dirFlowFields,i});
end
tic;									% Start a timer.
submit(job);
fprintf('\nJob 1 - Warp tasks submitted. Running...\n');
waitForState(job);
fprintf('Job 1 ended with state %s after %6.4f seconds.\n',job.state,toc);
alltasks=get(job,'Tasks');
allresults=get(alltasks,'OutputArguments');
%celldisp(allresults);						% Debug. Display all the times and status values.

% Check for errors.
errmsgs=get(job.Tasks,{'ErrorMessage'});			% Return the error results from each task as an array.
nonempty=~cellfun(@isempty,errmsgs);				% Check whether error array is non-empty.
celldisp(errmsgs(nonempty));						% Display any non-empty error messages of tasks in the job object.

% Check for success.
success=true;
for i=1:frames
    if allresults{i}{1}~=1							% ~cellfun(@(x) x(~=1),allresults{,1})
        success=false;
    end
    times(i)=allresults{i}{2};
end
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
    
    MeanFFieldFile=[allDir '\MeanWarp.mat'];
    
    % This task runs on just one worker, but needs all the files created by the previous task, before it can start.
    tasks_3{1}=createTask(job,@task_getMeanFlow,nWarpOutArgs,{MeanFFieldFile,warpDir,allDir});
    tic;									% Start a timer.
    submit(job);
    waitForState(job);
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
            %fprintf('Job 3 - Adding mean-rel-morph-vector task for frame %d...\n',i);	% Debug.
            thisFramePath=[dirSourceBitmaps frameNames(i).name];
            MeanFFieldFile=[allDir '\MeanWarp.mat'];
            tasks_4{i}=createTask(job,@task_getMorph,nWarpOutArgs,{thisFramePath,MeanFFieldFile,i,warpDir,morphDir});
        end
        tic;									% Start a timer.
        submit(job);
        waitForState(job);
        fprintf('\nJob 3 - Mean-rel-morph-vector job ended with state %s after %6.4f seconds.\n',job.state,toc);
        
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
            tasks_5{1}=createTask(job,@task_collectMorphVectors,nWarpOutArgs,{morphDir,allDir});
            tic;									% Start a timer.
            submit(job);
            waitForState(job);
            fprintf('Job 4 - Mean-rel-morph-vector job ended with state %s after %6.4f seconds.\n',job.state,toc);
            
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
                tasks_6{1}=createTask(job,@task_PCA,nWarpOutArgs,{allDir});
                tic;									% Start a timer.
                submit(job);
                waitForState(job);
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
