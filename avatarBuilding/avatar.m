function [  ] = avatar( c )
%Generates avatar.
%If autoGenPCAs is 1, avatar is generated from a folder of model folders.
%If randomSelect is 1, a random number of frames is taken.
allStartTime=tic;
maxWorkers=100;
nOutArgs1=2;
%This is superseded later if we are autogenerating PCA spaces

%ASSUMPTIONS:
%Input folders are numbered from 1 (maybe add a preprocessing stage to sort
%this out))
%disp('WARNING you hacked this not to do all PCAs.');

%STAGE CONTROL SWITCHES
switchRandomSelect=0;

switchPCA=0;
switchKeypoints=0;
switchProject=0;
switchTransform2=0;  %This does moving as well
switchAveraging=1; AveragingLocal=1;

switchPCA2=1;

%OPTIONS
buildCompareVideos=1;

transformToMean=0; %Whether we transform to the mean faceframe during the PROJECTION STEP (not second transformation)

copy=1;

%Paths for convenience

lp_output=rightPath(c,c.dirOutput);





%Handle autogeneration of PCA spaces
autoGen=0;

if switchRandomSelect
    
    pre_imageFolderList=dir(rightPath(c,c.dirSourceBitmaps));
    folder_it=1;
    for d=1:size(pre_imageFolderList,1)
        if pre_imageFolderList(d).isdir && not(strcmp(pre_imageFolderList(d).name,'.'))...
                && not(strcmp(pre_imageFolderList(d).name,'..'))
            imageFolderList(folder_it,1)=pre_imageFolderList(d);
            folder_it=folder_it+1;
        end
    end
    
    
end

if isfield(c,'autoGenPCAs')
    autoGen=1;
    cTemplate=config('AVATAR_PCA_TEMPLATE_FOR_AUTOGEN.pca');
    pre_imageFolderList=dir(rightPath(c,c.dirSourceBitmaps));
    %We assume the directories are ordered and there are no other
    %directories in here.
    folder_it=1;
    for d=1:size(pre_imageFolderList,1)
        if pre_imageFolderList(d).isdir && not(strcmp(pre_imageFolderList(d).name,'.'))...
                && not(strcmp(pre_imageFolderList(d).name,'..'))
            imageFolderList(folder_it,1)=pre_imageFolderList(d);
            folder_it=folder_it+1;
        end
    end
    
    models=size(imageFolderList,1); %If autogen is on, don't need to specify model numbers
    imageFolderList=numericalSortStruct(imageFolderList);
    for m=1:models
        cThisModel=cTemplate;
        cThisModel.h=c.h;
        cThismodel.w=c.w;
        %cThisModel.referenceFrames=c.referenceFrames(m);
        cThisModel.referenceFrameFiles{1}=c.referenceFrameFiles{m}; %Because this has to be a cell array
        cThisModel.dirSourceBitmaps=[c.dirSourceBitmaps imageFolderList(m).name '\'];
        cThisModel.clusterRoot=c.clusterRoot;
        cThisModel.localRoot=c.localRoot;
        cThisModel.dirPCAModel = [c.dirOutput 'modelPCAs\' num2str(m) '\'];
        cThisModel.PCs=c.PCs;
        cThisModel=rmfield(cThisModel, 'frames');
        
        modelConfigs{m}=cThisModel;
    end
else
    models=c.models;
    for m=1:models
        modelConfigs{m}=config(c.identities{m});
    end
end

%Setup parts which later parts depend on - these cannot be in the optional
%stages
for Ms=1:models
    cSource=modelConfigs{Ms};
    lp_thisSourceMorphFolder = [locPath(cSource,cSource.dirPCAModel) 'morph\'];
    thisSourceMorphFileList=dir([lp_thisSourceMorphFolder '*.mat']);
    nFramesInSource(Ms)=size(thisSourceMorphFileList,1);
    
    for Mt=1:models
        lp_thisOutputFolder= [rightPath(c,c.dirOutput)...
            num2str(Ms) 'to' num2str(Mt) '\'];
        projectingFolders{Ms,Mt}=lp_thisOutputFolder;
        rp_thisOutputFolder= [remPath(c,c.dirOutput)...
            num2str(Ms) 'to' num2str(Mt) '\'];
        rp_projectingFolders{Ms,Mt}=rp_thisOutputFolder;
    end
end



w=c.w;
h=c.h;

sched=findResource();

%Directories

rel_dirMeanFrames=[c.dirOutput 'meanFrames\'];
checkDir(rightPath(c,rel_dirMeanFrames));

lp_dirFinalPCA=[c.dirOutput 'finalPCA\'];
checkDir(rightPath(c,lp_dirFinalPCA));

DirMorphing = [rightPath(c,c.dirOutput) 'morphData\'];
if ~isdir(DirMorphing)
    mkdir(DirMorphing);
end

%Do PCAs

if switchPCA
    for m=1:models
        buildPCA(modelConfigs{m});
    end
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
    
    % for i=1:models
    
    
    
    for i = 1:ceil(models/2);
        
        % Taking images from Mean Morph as loaded from PCAModel.mat
        im1 =  squeeze(MorphMeansOut(:,:,:,(2*i-1)));
        if 2*i > models
            %If odd number of models, use the first model for the final
            %control point tool image.
            im2 = squeeze(MorphMeansOut(:,:,:,(1)));
            disp('Odd number of models, dummy second frame.');
        else
            im2 = squeeze(MorphMeansOut(:,:,:,(2*i)));
        end
        
        %         % Taking images from mean as extracted from PCAModels
        %         im1 =  squeeze(MeansOut(:,:,:,(2*i-1)));
        %         im2 = squeeze(MeansOut(:,:,:,(2*i)));
        
        [first_points, second_points] = cpselect(im1,im2, 'Wait', true);
        
        cpstack(:,:,2*i-1) = first_points;
        if 2*i <= models
            %Only fill in if it's not a dummy
            cpstack(:,:,2*i) = second_points;
        end
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
    %end
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
        [c.replicatedRoot 'Code\common\'],...
        [c.replicatedRoot 'Code\avatarBuilding'],...
        [c.replicatedRoot 'Code\motionTransfer']};		% UNC paths to any other folders needed by the workers to execute their tasks.
    set(job,'PathDependencies',paths);
    
    %PSEUDOCODE FOR THE FOLLOWING NESTED LOOPS:
    %For all sources
    %For all targets
    %For framesPerIdentity frames in the source,
    %Project frame from source to target and save.
    
    task_it=1; %Task counter for this job
    for Ms=1:models %Iterate over source models
        
        %Load morph mean of source identity
        cSource=modelConfigs{Ms};
        lp_sourceMorphMean=[rightPath(cSource,cSource.dirPCAModel) '\all\MorphMean'];
        load_mm=load(lp_sourceMorphMean);
        
        for Mt=1:models %Iterate over target models
            
            lp_thisOutputFolder= [rightPath(c,c.dirOutput)...
                num2str(Ms) 'to' num2str(Mt) '\'];
            projectingFolders{Ms,Mt}=lp_thisOutputFolder;
            rp_thisOutputFolder= [remPath(c,c.dirOutput)...
                num2str(Ms) 'to' num2str(Mt) '\'];
            rp_projectingFolders{Ms,Mt}=rp_thisOutputFolder;
            checkFolder(lp_thisOutputFolder);
            
            %Get path to the target's PCA model
            cTarget=modelConfigs{Mt};
            thisTargetPCAModel = [remPath(cTarget,cTarget.dirPCAModel) 'all\PCAModel.mat'];
            lp_thisTargetPCAModel = [locPath(cTarget,cTarget.dirPCAModel) 'all\PCAModel.mat'];
            
            rp_thisTargetMorphFolder = [remPath(cTarget,cTarget.dirPCAModel) 'morph\'];
            lp_thisTargetMorphFolder = [locPath(cTarget,cTarget.dirPCAModel) 'morph\'];
            thisTargetMorphFileList=dir([lp_thisTargetMorphFolder '*.mat']);
            
            %Get path to the source's morph folder
            thisSourcePCAModel = [remPath(cSource,cSource.dirPCAModel) 'all\PCAModel.mat'];
            lp_thisSourcePCAModel = [locPath(cSource,cSource.dirPCAModel) 'all\PCAModel.mat'];
            
            rp_thisSourceMorphFolder = [remPath(cSource,cSource.dirPCAModel) 'morph\'];
            lp_thisSourceMorphFolder = [locPath(cSource,cSource.dirPCAModel) 'morph\'];
            thisSourceMorphFileList=dir([lp_thisSourceMorphFolder '*.mat']);
            nFramesInSource(Ms)=size(thisSourceMorphFileList,1);
            
            
            %Calculate source->target transform
            source_points = cpstack(:, :, Ms);
            dest_points = cpstack(:, :, Mt);
            mean_points=mean(cpstack,3);
            
            % Find transform to map source model onto destination model
            if transformToMean
                T = cp2tform(source_points, mean_points, 'affine');
            else
                T = cp2tform(source_points, dest_points, 'affine');
            end
            
            %Realign the bleeding source mean morph vector (this one took
            %ages to find)
            
            M_i=load_mm.MorphMean;
            MTPx = reshape(M_i(1:w*h), h, w);
            MTPy = reshape(M_i(1+w*h : 2*w*h), h, w);
            MTex = reshape(M_i(1+2*w*h : end), [h, w, 3]);
            TM_i = Affine_Transform(MTPx, MTPy, MTex, T, w, h);
            
            
            checkFolder([lp_thisOutputFolder '\morph']);
            
            
            fprintf('Adding transfer task from model %d to %d...\n',Ms,Mt);
            
            tasks_1{task_it}=createTask(job,@task_transfer_util_group,nOutArgs1,...
                {rp_thisOutputFolder,rp_thisTargetMorphFolder,...
                rp_thisSourceMorphFolder,nFramesInSource(Ms),h,w,thisTargetPCAModel,T,TM_i,...
                rp_thisOutputFolder,buildCompareVideos,c.transform1,c.transform1CaricCoeff});
            
            task_it=task_it+1;
            
            %(job,@task_transfer_util,nOutArgs1,...
            % {h,w,thisTargetPCAModel,rp_thisSourceMorphVector,T,load_mm.MorphMean,rp_thisOutputFolder,f});
            
            %This is the version that did one frame at a time:
            %             for f=1:c.framesPerIdentity %Iterate over frames from this source model
            %
            %                 %Set up task parameters
            %                 rp_thisSourceMorphVector = [rp_thisSourceMorphFolder thisSourceMorphFileList(f).name];
            %
            %                 %Set up task for this individual warp
            %                 fprintf('Adding transfer task from model %d to %d, frame %d...\n',Ms,Mt,f);
            %                 string='\\stuff.dot\more';
            %                 myNum=uint8(string);
            %                 tasks_1{task_it}=createTask(job,@task_transfer_util,nOutArgs1,...
            %                 {h,w,thisTargetPCAModel,rp_thisSourceMorphVector,T,load_mm.MorphMean,rp_thisOutputFolder,f});
            %             %task_transfer_util(h,w,thisTargetPCAModel,rp_thisSourceMorphVector,T,load_mm.MorphMean,rp_thisOutputFolder,f)
            %                 task_it=task_it+1;
            %
            %
            %             end
            
        end
    end
    submit(job);
    jobMonitor(job)
end


%Intermediate prep needed by later stages

for Ms=1:models
        for e=1:nFramesInSource(Ms)
            expDirs{Ms,e} = ['exps\m' num2str(Ms) 'exp' num2str(e) '\']; %This is rel to the root
            checkDir(rightPath(c,[c.dirOutput expDirs{Ms,e}]));
        end
    end
root=rightPath(c,c.dirOutput);
img_it=1;
    img_col_it=1;
for Ms=1:models
        for e=1:nFramesInSource(Ms)
            for Mt=1:models
                target = [root expDirs{Ms,e} 'trans\frame'  num2str(e,'%03d') '_model' num2str(Mt) '.bmp'];
                prelim_imgCell{img_it,img_col_it}=loc2Rem(c,target);
                ref=[root expDirs{Ms,e} 'trans\frame'  num2str(e,'%03d') '_model' num2str(c.referenceModel) '.bmp'];
                prelim_refCell{img_it,1}=loc2Rem(c,ref);
                img_col_it=img_col_it+1;
            end
            img_col_it=1;
            img_it=img_it+1;
        end
    end

%-------------------------------------------------------------------------------------------------BEGIN second transform code
if switchTransform2
    
    %Changing this to put each expression in its own folder for easy
    %access.
    
    %Create all the individual expression folders
    
    expStorageDir = ['exps'];
    checkDir(rightPath(c,[c.dirOutput expStorageDir]));
    
    
    
    %Copy things into the expression folders so we can eyeball them
    
    
    
    
    
    trans_it=1;
    
    for Ms=1:models
        Ms
        for Mt=1:models
            Mt
            for e=1:nFramesInSource(Ms)
                
                source = [projectingFolders{Ms,Mt} 'frame' num2str(e,'%03d') '.bmp'];
                target = [root expDirs{Ms,e} 'frame'  num2str(e,'%03d') '_model' num2str(Mt) '.bmp'];
                
                prelim_transCell{trans_it,1}=loc2Rem(c,source);
                prelim_transCell{trans_it,2}=Mt;
                prelim_transCell{trans_it,3}=c.referenceModel;
                
                prelim_transOutPath=[root expDirs{Ms,e} 'trans\frame' num2str(e,'%03d') '_model' num2str(Mt) '.bmp'];
                prelim_transOutCell{trans_it,1}=loc2Rem(c,prelim_transOutPath);
                
                trans_it=trans_it+1;
                
                %copyfile(source,target);
            end
        end
    end
    
    
    
    
    
    1
    
    %We start by transforming everything onto a reference model.
    %Prep transform folders
    
    for Ms=1:models
        for e=1:nFramesInSource(Ms)
            transFolder=[root expDirs{Ms,e} 'trans\'];
            checkDir(transFolder);
        end
    end
    
    %     for Ms=1:models
    %         for Mt=1:models
    %         transDir = [projectingFolders{Ms,Mt} '\trans'];
    %             checkDir(transDir);
    %         end
    %     end
    
    %Make a cell with all the image paths
    %DATASTRUCTURE: a 3-COLUMN CELL . COLUMN 1 is a list of RP filenames to
    %transform, column 2 is a list of which identities they come from, column 3
    %is a list of which identities they have been transferred to.
    
    %AllTransOutPathsCell is the same, but it gives target images.
    
    %     it=1;
    %     for Ms=1:models
    %
    %         for Mt=1:models
    %             for f=1:nFramesInSource(Ms)
    %
    %                 if 1 %Switch this off for local debugging!
    %                     allTransPathsCell{it,1}=[rp_projectingFolders{Ms,Mt} 'frame' num2str(f,'%03d') '.bmp' ];
    %                     allTransPathsCell{it,2}=Ms;
    %                     allTransPathsCell{it,3}=Mt;
    %                     allTransOutPathsCell{it,1}=[rp_projectingFolders{Ms,Mt} 'trans\frame' num2str(f,'%03d') '.bmp' ];
    %
    %                 else
    %                    allTransPathsCell{it,1}=[projectingFolders{Ms,Mt} 'frame' num2str(f,'%03d') '.bmp' ];
    %                     allTransPathsCell{it,2}=Ms;
    %                     allTransPathsCell{it,3}=Mt;
    %
    %                     allTransOutPathsCell{it,1}=[projectingFolders{Ms,Mt} 'trans\frame' num2str(f,'%03d') '.bmp' ];
    %
    %                 end
    %                 it=it+1;
    %             end
    %
    %
    %         end
    %     end
    %
    %     %Now let's do the task sectioning.
    %
    %Link up
    
    allTransPathsCell=prelim_transCell;
    allTransOutPathsCell=prelim_transOutCell;
    job=prepareJob(c,maxWorkers);
    
    ops=sum(nFramesInSource*models); %One op is a transfer task for one frame; there are expressions * models frames in total.
    opsPerTask=ceil(ops/maxWorkers);
    lastOpAdded=0;
    
    load([DirMorphing 'cpstack.mat']); %Load in the keypoints
    
    for i=1:maxWorkers
        
        firstOp=(i-1)*opsPerTask +1;
        finalOp=min(i*opsPerTask,ops);
        
        transPathCell=allTransPathsCell(firstOp:finalOp,:);
        transOutPathCell=allTransOutPathsCell(firstOp:finalOp,:); %You have to use brackets when copying a cell array to another.
        
        
        
        
        
        if lastOpAdded < ops
            fprintf('Adding warp/morph/mean matrix task %d.\n',i);
            %toMatrix converts the 2D cell to a 3D padded matrix because Matlab
            %interprets cell arrays as a command to launch multiple tasks.
            transPathMatrix=toMatrix(transPathCell);
            transOutPathMatrix=toMatrix(transOutPathCell);
            
            tasks_2{i}=createTask(job,@task_transform2,nOutArgs1,...
                {transPathMatrix,transOutPathMatrix,cpstack});
        end
        
    end
    
    submit(job);
    fprintf('\nJob 1 - Warp tasks submitted. Running...\n');
    %waitForState(job);
    jobMonitor(job);
    
    
    
    
end
%----------------------------------BEGIN averaging code
if switchAveraging
    
    
    job=prepareJob(c,maxWorkers);
    
    %Make a number of tasks equal to the number of available cores
    
    
    ops=sum(nFramesInSource); %One op is one averaging task - for one expression. There are several images for each expression, of course.
    opsPerTask=ceil(ops/maxWorkers);
    lastOpAdded=0;
    
    it=1;
    for Ms=1:models
        
        for f=1:nFramesInSource(Ms)
            for Mt=1:models
                
                if 1 %Switch this off for local debugging!
                    allImgPathsCell{it,Mt}=[rp_projectingFolders{Ms,Mt} 'frame' num2str(f,'%03d') '.bmp' ];
                    
                    allRefPathsCell{it,1}=[rp_projectingFolders{Ms,Mt} 'frame' num2str(c.referenceModel,'%03d') '.bmp' ];
                    allMeanFramePathsCell{it,1} = [remPath(c,c.dirOutput) 'meanFrames\model' num2str(Ms) 'frame' num2str(it) '.bmp'];
                else
                    allImgPathsCell{it,Mt}=[projectingFolders{Ms,Mt} 'frame' num2str(f,'%03d') '.bmp' ];
                    
                    allRefPathsCell{it,1}=[projectingFolders{Ms,Mt} 'frame' num2str(c.referenceModel,'%03d') '.bmp' ];
                    allMeanFramePathsCell{it,1} = [locPath(c,c.dirOutput) 'meanFrames\model' num2str(Ms) 'frame' num2str(it) '.bmp'];
                end
            end
            
            it=it+1;
        end
    end
    
    allImgPathsCell=prelim_imgCell;
    allRefPathsCell=prelim_refCell;
    
    for i=1:maxWorkers
        
        firstOp=(i-1)*opsPerTask +1;
        finalOp=min(i*opsPerTask,ops);
        
        imgPathCell=allImgPathsCell(firstOp:finalOp,:);
        refPathCell=allRefPathsCell(firstOp:finalOp,:); %You have to use brackets when copying a cell array to another.
        outPathCell=allMeanFramePathsCell(firstOp:finalOp,:);
        
        if AveragingLocal
            [sR sC]=size(imgPathCell);
            for iR=1:sR
                for iC=1:sC
                    imgPathCell{iR,iC}=rem2Loc(c,imgPathCell{iR,iC});
                end
            end
            
            [sR sC]=size(outPathCell);
            for iR=1:sR
                for iC=1:sC
                    outPathCell{iR,iC}=rem2Loc(c,outPathCell{iR,iC});
                end
            end
            %Ref cell is the same size
            for iR=1:sR
                for iC=1:sC
                    refPathCell{iR,iC}=rem2Loc(c,refPathCell{iR,iC});
                end
            end
        end
        
        imgPathMatrix=toMatrix(imgPathCell);
                refPathMatrix=toMatrix(refPathCell);
                outPathMatrix=toMatrix(outPathCell);
        
        if lastOpAdded < ops
            if not(AveragingLocal)
                fprintf('Adding warp/morph/mean matrix task %d.\n',i);
                %toMatrix converts the 2D cell to a 3D padded matrix because Matlab
                %interprets cell arrays as a command to launch multiple tasks.
                
                
                
                tasks_2{i}=createTask(job,@task_warpMorphMean_matrix,nOutArgs1,...
                    {imgPathMatrix,refPathMatrix,outPathMatrix});
            else
                %Localise paths
                
                
                fprintf('DOING warp/morph/mean matrix task %d.\n',i);
                task_warpMorphMean_matrix(imgPathMatrix,refPathMatrix,outPathMatrix);
            end
        end
        
    end
    
    
    if not(AveragingLocal)
        submit(job);
        fprintf('\nJob 1 - Warp tasks submitted. Running...\n');
        %waitForState(job);
        jobMonitor(job);
    end
    
    
end

if switchPCA2
    
    cTemplate=config('AVATAR_PCA_TEMPLATE_FOR_AUTOGEN.pca');
    cThisModel=cTemplate;
    cThisModel.h=c.h;
    cThismodel.w=c.w;
    %cThisModel.referenceFrames=modelConfigs{c.referenceModel}.referenceFrames;
    cThisModel.referenceFrameFiles=modelConfigs{c.referenceModel}.referenceFrameFiles;
    cThisModel.dirSourceBitmaps=rel_dirMeanFrames; %This path needs to be rel to the root
    cThisModel.clusterRoot=c.clusterRoot;
    cThisModel.localRoot=c.localRoot;
    cThisModel.dirPCAModel = [c.dirOutput 'finalPCA\']; %This path needs to be rel to the root
    
    cThisModel.PCs=c.PCs;
    cThisModel=rmfield(cThisModel, 'frames');
    
    save(rightPath(c,[c.dirOutput 'finalPCA\config.mat']),'cThisModel');
    
    cThisModel=rmfield(cThisModel,'referenceFrames');
    hack=input('Need to insert line saying, take ref. im. of refmodel! Save its number earlier.','s');
    cThisModel.referenceFrameFiles{1}=hack;
    buildPCA(cThisModel);
    
    
end




tt=toc(allStartTime);
fprintf('All the jobs have been run successfully.\n\nTotal time taken was %10.6f secs.\n',tt);
end

