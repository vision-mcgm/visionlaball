function [  ] = avatar( c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
allStartTime=tic;
maxWorkers=115;
nOutArgs1=2;
models=c.models;


switchKeypoints=0;
switchProject=1;

for m=1:models
    modelConfigs{m}=config(c.identities{m});
end

models=size(c.identities,2);

w=c.w;
h=c.h;

%Directories

DirMorphing = [rightPath(c,c.dirOutput) 'morphData\'];
if ~isdir(DirMorphing)
    mkdir(DirMorphing);
end

%Find keypoints

if switchKeypoints
    
    %Load in morph means
    
    for i=1:models
        
        ModelMorphMeanFile = [rightPath(modelConfigs{i},modelConfigs{i}.dirPCAModel) 'all\MorphMean.mat'];
        load(ModelMorphMeanFile);
        out2 = morphvec2image(c,MorphMean);
        MorphMeansOut(:,:,:,i) = out2;
        
    end
    
    for i=1:models
        
        
        
        for i = 1:models/2;
            
            % Taking images from Mean Morph as loaded from PCAModel.mat
            im1 =  squeeze(MorphMeansOut(:,:,:,(2*i-1)));
            im2 = squeeze(MorphMeansOut(:,:,:,(2*i)));
            
            %         % Taking images from mean as extracted from PCAModels
            %         im1 =  squeeze(MeansOut(:,:,:,(2*i-1)));
            %         im2 = squeeze(MeansOut(:,:,:,(2*i)));
            
            [first_points, second_points] = cpselect(im1,im2, 'Wait', true);
            
            cpstack(:,:,2*i-1) = first_points;
            cpstack(:,:,2*i) = second_points;
        end
        save([DirMorphing 'cpstack.mat'], 'cpstack')
        fprintf('Plotting morph means and CPs\n\n')
        
        for i = 1 : models  % Identity - source sequence - (a)
            subplot(4,2,i);
            hold on
            
            imshow(MorphMeansOut(:,:,:,i));
            title(i);
            
            for j = 1:4
                scatter(cpstack(j,1,i), cpstack(j,2,i));
            end
            
        end
    end
else
    %If we haven't done the keypoint collection, load them in.
    load([DirMorphing 'cpstack.mat']);
end





%----------------------BEGIN PROJECT-TO-ALL-IDENTITIES STEP


if switchProject
    
    
    
    

    
    sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    
    %THIS IS THE IMPORTANT PATH-SETTING PART.
    paths={c.replicatedRoot,[c.replicatedRoot 'Code\matlab-helpers\'],[c.replicatedRoot 'Code\'],...
       [c.replicatedRoot 'Code\avatarBuilding'] };		% UNC paths to any other folders needed by the workers to execute their tasks.
    set(job,'PathDependencies',paths);
    
    %PSEUDOCODE FOR THE FOLLOWING NESTED LOOPS:
    %For all sources
    %For all targets
    %For framesPerIdentity frames in the source,
    %Project frame from source to target and save.
    
    task_it=1; %Task counter for this job 
    for Ms=1:1 %Iterate over source models
        
        %Load morph mean of source identity
        cSource=modelConfigs{Ms};
        lp_sourceMorphMean=[rightPath(cSource,cSource.dirPCAModel) '\all\MorphMean'];
        load_mm=load(lp_sourceMorphMean);
        
        for Mt=1:1 %Iterate over target models
            
            lp_thisOutputFolder= [rightPath(c,c.dirOutput)...
                num2str(Ms) 'to' num2str(Mt) '\'];
            rp_thisOutputFolder= [remPath(c,c.dirOutput)...
                num2str(Ms) 'to' num2str(Mt) '\'];
            checkFolder(lp_thisOutputFolder);
            
            %Get path to the target's PCA model
            cTarget=modelConfigs{Mt};
            thisTargetPCAModel = [remPath(cTarget,cTarget.dirPCAModel) 'all\PCAModel.mat'];
            
            rp_thisTargetMorphFolder = [remPath(cTarget,cTarget.dirPCAModel) 'morph\'];
            lp_thisTargetMorphFolder = [locPath(cTarget,cTarget.dirPCAModel) 'morph\'];
            thisTargetMorphFileList=dir([lp_thisTargetMorphFolder '*.mat']);
            
            %Calculate source->target transform
             source_points = cpstack(:, :, Ms);
        dest_points = cpstack(:, :, Mt);
        
        % Find transform to map source model onto destination model
        T = cp2tform(source_points, dest_points, 'affine');
            
            
            for f=1:c.framesPerIdentity %Iterate over frames from this source model
                
                %Set up task parameters
                rp_thisSourceMorphVector = [rp_thisTargetMorphFolder thisTargetMorphFileList(f).name];
                
                %Set up task for this individual warp
                fprintf('Adding transfer task from model %d to %d, frame %d...\n',Ms,Mt,f);
                string='\\stuff.dot\more';
                tasks_1{task_it}=createTask(job,@task_transfer_util,nOutArgs1,...
                    {string});
                %{h,w,thisTargetPCAModel,rp_thisSourceMorphVector,T,load_mm.MorphMean,rp_thisOutputFolder,f});
                task_it=task_it+1;
                
                
            end
            
        end
    end
end

submit(job);
jobMonitor(job)
        %End code front
        
        %Load required data
        disp('Loading data...');
        disp('Keypoints...');
        keypoints=load(rightPath(c, c.keypoints));
        
        source_points = keypoints.cpstack(:, :, 1);
        dest_points = keypoints.cpstack(:, :, 2);
        T = cp2tform(source_points, dest_points, 'affine');
        
        disp('Source morph mean...');
        load([rightPath(c1, c1.dirPCAModel) 'all\MorphMean.mat']);
        M_i=MorphMean; %Morph mean of the source
        
        disp('Target PCA model...');
        load([rightPath(c2,c2.dirPCAModel) 'all\PCAModel.mat']);
        disp('Copying variables...');
        %Target PCA model and morph vec.
        if exist('PCA')
            P_j=PCA;
        elseif exist('pcTrimmed')
            P_j=pcTrimmed;
        end
        if exist('MeanMorph')
            M_j=MeanMorph;
        elseif exist('MorphMean')
            M_j=MorphMean;
        end
        
        % Realign the source mean morph vector
        MTPx = reshape(M_i(1:w*h), h, w);
        MTPy = reshape(M_i(1+w*h : 2*w*h), h, w);
        MTex = reshape(M_i(1+2*w*h : end), [h, w, 3]);
        TM_i = Affine_Transform(MTPx, MTPy, MTex, T, w, h);
        disp('Doing mapping...');
        
        morphVecFiles=dir([rightPath(c1,c1.dirPCAModel) 'morph\*.mat']);
        
        clusterRoot=c.clusterRoot;
        %THIS IS THE IMPORTANT PATH-SETTING PART.
        paths={[c.replicatedRoot 'Code\matlab-helpers'],...
            [c.replicatedRoot 'Code']};		% UNC paths to any other folders needed by the workers to execute their tasks.
        set(job,'PathDependencies',paths);
        
        
        
        
        for i=1:c.frames
            fprintf('Adding transfer task for frame %d...\n',i);
            
            tasks_1{i}=createTask(job,@task_transfer,nOutArgs1,{c,i,T,TM_i,morphVecFiles});
            
        end
        
        
        submit(job);
        jobMonitor(job);
        %waitForState(job);
        
        %checkOK(tasks_1);
        
        tt=toc(allStartTime);
        fprintf('All the jobs have been run successfully.\n\nTotal time taken was %10.6f secs.\n',tt);
    end
    
