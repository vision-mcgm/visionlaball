 function [  ] = transfer( c )
 
 c1=config(c.sourceConf);
c2=config(c.targetConf);

transfer_util(c,c1,c2);
 end

% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% allStartTime=tic;
% maxWorkers=115;
% nOutArgs1=2;
% 
% 
% c1=config(c.sourceConf);
% c2=config(c.targetConf);
% 
% w=c1.w;
% h=c1.h;
% 
% checkDir([c.dirOutput 'comp']);
% if ~isdir(rightPath(c,c.dirOutput))
%             mkdir(rightPath(c,c.dirOutput));
%         end
% 
% sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
% job=createJob(sched);
% set(job,'MaximumNumberOfWorkers', maxWorkers);
% set(job,'MinimumNumberOfWorkers',1);
% 
% 
% 
% %Load required data
% disp('Loading data...');
% disp('Keypoints...');
% keypoints=load(rightPath(c, c.keypoints));
% 
% source_points = keypoints.cpstack(:, :, 1);
% dest_points = keypoints.cpstack(:, :, 2);
% T = cp2tform(source_points, dest_points, 'affine');
% 
% disp('Source morph mean...');
% load([rightPath(c1, c1.dirPCAModel) 'all\MorphMean.mat']);
% M_i=MorphMean; %Morph mean of the source
% 
% disp('Target PCA model...');
% load([rightPath(c2,c2.dirPCAModel) 'all\PCAModel.mat']);
% disp('Copying variables...');
% %Target PCA model and morph vec.
% if exist('PCA')
% P_j=PCA;
% elseif exist('pcTrimmed')
%     P_j=pcTrimmed;
% end
% if exist('MeanMorph')
% M_j=MeanMorph;
% elseif exist('MorphMean')
%     M_j=MorphMean;
% end
% 
% % Realign the source mean morph vector
% MTPx = reshape(M_i(1:w*h), h, w);
%         MTPy = reshape(M_i(1+w*h : 2*w*h), h, w);
%         MTex = reshape(M_i(1+2*w*h : end), [h, w, 3]);
%         TM_i = Affine_Transform(MTPx, MTPy, MTex, T, w, h);
% disp('Doing mapping...');
% 
% morphVecFiles=dir([rightPath(c1,c1.dirPCAModel) 'morph\*.mat']);
% 
% clusterRoot=c.clusterRoot;
% %THIS IS THE IMPORTANT PATH-SETTING PART.
% 
% paths={c.replicatedRoot,[c.replicatedRoot 'Code\matlab-helpers\'],[c.replicatedRoot 'Code\'],...
%     [c.replicatedRoot 'Code\motionTransfer']};		% UNC paths to any other folders needed by the workers to execute their tasks.
% set(job,'PathDependencies',paths);
% 
% if isfield(c,'carifCoeff')
% caric=c.caricCoeff;
% else
%     caric=1;
% end
% 
% for i=1:c.frames
%     fprintf('Adding transfer task for frame %d...\n',i);	
%     
%     tasks_1{i}=createTask(job,@task_transfer,nOutArgs1,{c,i,T,TM_i,morphVecFiles,caric});
%     
% end
% 
% 
% submit(job);
% jobMonitor(job);
% %waitForState(job);
% 
% %checkOK(tasks_1);
% 
% tt=toc(allStartTime);
%                     fprintf('All the jobs have been run successfully.\n\nTotal time taken was %10.6f secs.\n',tt);
% end
% 
