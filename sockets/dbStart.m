
function [  ] = dbStart(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clusterRoot='\\komodo\SharedData\Fintan\';	
c=config('altixDiag.pca');
nOutputArgs=4;
sched=findResource;
job=createJob(sched);
maxWorkers=1;
set(job,'MaximumNumberOfWorkers', maxWorkers);
set(job,'MinimumNumberOfWorkers',1);

rootDir = '\\komodo.psychol.ucl.ac.uk\JobData1\VisionLabLibrary\Code\rathore';
rootDirR='C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev';
rootDir2='C:\Export\JobData1\VisionLabLibrary\Code\rathore';
paths={c.replicatedClusterRoot,[c.replicatedClusterRoot 'Code\matlab-helpers\'],[c.replicatedClusterRoot 'Code\'],...
   [c.replicatedClusterRoot 'Code\sharePipe'],...
   ['C:\Export\JobData1\VisionLabLibrary\Code\rathore\Dev\'],...
   [c.replicatedClusterRoot 'Code\sockets'],...
   [c.replicatedClusterRoot 'Code\mcgm'],...
   [c.replicatedClusterRoot 'Code\motionTransfer'],...
   [rootDirR '\Dev'],...
    [rootDir2 '\ShufflingandConservativeScoring\mtint core functions'],...
    [rootDir2 '\ShufflingandConservativeScoring\mtint core functions\pxd']};		% UNC paths to any other folders needed by the workers to execute their tasks.
set(job,'PathDependencies',paths);

task=createTask(job,@t_dbStart,nOutputArgs,{});

submit(job);

'submitted'

pause(15);

ips{1}='128.40.31.182';
ips{2}='128.40.31.183';
ips{3}='128.40.31.181';
ips{4}='128.40.31.188';
ips{5}='10.0.0.1';
ips{6}='128.40.31.189';
ips{7}='128.40.31.186';
ips{8}='128.40.31.187';
ips{9}='128.40.31.184';
ips{10}='128.40.31.185';
ips{12}='128.40.31.163';
ips{13}='128.40.31.162';
ips{14}='128.40.31.175';
ips{15}='128.40.31.165';
ips{16}='128.40.31.224';
ips{17}='128.40.31.164';
ips{18}='128.40.31.173';


for i=1:18
    i
    try
    tcpipClient = tcpip(ips{i},55000,'NetworkRole','Client')
    set(tcpipClient,'InputBufferSize',7688);
    set(tcpipClient,'Timeout',1);
    fopen(tcpipClient);
    end
end
    
    

end

