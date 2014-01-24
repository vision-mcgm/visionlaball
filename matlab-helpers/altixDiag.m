
function [  ] = altixDiag( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clusterRoot='\\komodo\SharedData\Fintan\';	
disp(4);
if nargin==0
    c=config('altixDiag.pca');
else
    c=varargin{1};
end

paths={['\\komodo\SharedData\Fintan\AltixCode\test\functioncall']};

nOutputArgs=4;
sched=findResource;
job=createJob(sched,'PathDependencies',paths);
maxWorkers=1;
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);

rootDir = '\\komodo.psychol.ucl.ac.uk\JobData1\VisionLabLibrary\Code\rathore';
rootDirR='C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev';
rootDir2='C:\Export\JobData1\VisionLabLibrary\Code\rathore';
%Path dependencies from altixDiag
paths={c.replicatedClusterRoot,[c.replicatedClusterRoot 'Code\matlab-helpers\'],[c.replicatedClusterRoot 'Code\'],...
   [c.replicatedClusterRoot 'Code\sharePipe'],...
   ['C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev\'],...
   [c.replicatedClusterRoot 'Code\sockets'],...
   [c.replicatedClusterRoot 'Code\mcgm'],...
   [c.replicatedClusterRoot 'Code\motionTransfer'],...
   [c.replicatedClusterRoot 'Code\common'],...
   ['\\komodo\SharedData\Fintan\MarionSaroul\'],...
    [clusterRoot 'tests\mexfiles']};

paths={['C:\Export\JobData1\VisionLabLibrary\Code\matlab-helpers\'],...
   };



% UNC paths to any other folders needed by the workers to execute their tasks.
%set(job,'PathDependencies',paths2);		% UNC paths to any other folders needed by the workers to execute their tasks.


task=createTask(job,@task_diag,nOutputArgs,{});

submit(job);

%waitForState(job);

jobMonitor(job);

allresults=get(task,'OutputArguments');

celldisp(allresults)	

errmsgs=get(job.Tasks,{'ErrorMessage'});			% Return the error results from each task as an array.
nonempty=~cellfun(@isempty,errmsgs);				% Check whether error array is non-empty.
celldisp(errmsgs(nonempty));


end

