
function [  ] = altixDiag(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clusterRoot='\\komodo\JobData1\VisionlabLibrary\';	
replicatedRoot='X:\VisionLabLibrary\';



nOutputArgs=4;
sched=findResource;
job=createJob(sched);
maxWorkers=1;
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);

paths={['\\komodo\SharedData\Fintan\AltixCode\debug']};

set(job,'PathDependencies',paths);


task=createTask(job,@task_diag2,nOutputArgs,{});

submit(job);

waitForState(job);

allresults=get(task,'OutputArguments');

celldisp(allresults);	

errmsgs=get(job.Tasks,{'ErrorMessage'});			% Return the error results from each task as an array.
nonempty=~cellfun(@isempty,errmsgs);				% Check whether error array is non-empty.
celldisp(errmsgs(nonempty));


end

