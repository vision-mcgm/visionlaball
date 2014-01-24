function [  ] = sliceAndSend(f,all,args)
%sliceAndSend takes a function and a list of operation parameters, ARGS.
%Each row in
%Assumes args is a struct COLVEC with OPS rows
%control is a struct created by SliceAndSend with

%Params
n=120;
nOutArgs=0;
nInArgs=size(args,2);
c=config('template.pca');
clusterRoot=c.replicatedClusterRoot;

%Error checking
if size(args,1)==1
    error('Args must be a col vec');
end



%create and task
for arg=1:nInArgs
    nargs(arg)=size(args,1);
end
ops=size(args,1); %HACK - we should check to make sure all the args are the same size
opsPerTask = ceil(ops/n);

%Connect
sched=findResource();
fprintf('Scheduler found.\n');
job=createJob(sched);
fprintf('Job created.\n');
set(job,'PathDependencies',altixPaths);
for i=1:n
    
    firstOp=(i-1)*opsPerTask +1;
    finalOp=min(i*opsPerTask,ops);
    if firstOp<=ops
        fprintf('Dispatching task %d of %d: ops %d to %d.\n',i,n,firstOp,finalOp);
        
        sliceArgStruct=args(firstOp:finalOp,:);
        
        
        %The arg in here must be a row cell array. If it's a cell array of cell
        %arrays, a separate one is created for each task.
        allForThisNode=all;
        allForThisNode.node=i;
        tasks{i}=createTask(job,f,nOutArgs,{allForThisNode,sliceArgStruct});
        maxTasks=i;
    end
    
end

submit(job);
fprintf('%d operations submitted in %d tasks.\n',i,n);
jobMonitor(job);

errs=0;
for i=1:maxTasks
    msg=tasks{i}.ErrorMessage;
    if length(msg)>0
        fprintf('Task %d has error: %s\n',i,msg);
        errs=errs+1;
    end
end

fprintf('There were %d errors.\n',errs);



destroy(job);