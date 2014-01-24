function [  ] = altix( f )
%Launch a single task on Altix - at the moment with no args

nOutArgs=0;

c=config('template.pca');
clusterRoot=c.replicatedClusterRoot;

%Connect
sched=findResource();
fprintf('Scheduler found.\n');
job=createJob(sched);
fprintf('Job created.\n');
set(job,'PathDependencies',altixPaths);

task=createTask(job,f,nOutArgs,{});
submit(job);
jobMonitor(job)

keyboard

end

