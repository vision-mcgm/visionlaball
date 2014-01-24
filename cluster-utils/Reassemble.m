function [ results ] = Reassemble(all,type  )
%Collects the individual result matrices from a SliceAndSend operation
%Params
n=120;
ops=80200;

 fprintf('Reassembling %d ops...\n',ops);

%Prep
opsPerTask = ceil(ops/n);


if strcmp(type,'cell'), cellReturn=1;
results=cell(ops,1);
else cellReturn=0; end

if strcmp(type,'matrix'), matrix=1;
results=zeros(ops,1);
else matrix=0; end

%Work

for i=1:n
    firstOp=(i-1)*opsPerTask +1;
    finalOp=min(i*opsPerTask,ops);
    fprintf('Reassembling slice %d: ops %d to %d...\n',i,firstOp,finalOp);
    slice=load([rem2Loc(all.outFolder) 'results' num2str(i,'%03d') '.mat']);
    if matrix
        results(firstOp:finalOp,1)=slice.sliceResults;
    end
    if cellReturn
        results{firstOp:finalOp,1}=slice.sliceResults;
    end
end
        
    
    

end

