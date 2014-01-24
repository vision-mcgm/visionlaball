function [ ok,tFin ] = task_transfer_util_group(rp_thisOutputFolder,rp_thisTargetMorphFolder,...
    rp_thisSourceMorphFolder,nFrames,h,w,path_targetPCAModel,T,TM_i,outputDir,buildCompareVideos,transform,caric)
%for single frame version:task_transfer_util_group(h,w,path_targetPCAModel,path_sourceMorphVector,T,TM_i,outputDir,j)

%Transforms a whole group of frames at once - for one combination of source
%PCA to target PCA.

%h,w: height, width
%path_targetPCAModel : path to target PCA model
%path_sourceMorphVector : path to source morph vector IN COMPONENT FORM
%(texture and warp)
% T: the transform
%TM_i: MorphMean of source identity
% outputDir: output directory
% j: number to tag output frame with
tStart=tic;

compare=1;

 %Do the transform first?;

%caric=1; %caricaturing coefficient


%Bits from above layer

checkFolder(rp_thisOutputFolder);
thisSourceMorphFileList=dir([rp_thisSourceMorphFolder '*.mat']);
load(path_targetPCAModel);

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

%Make compare folder

compPath=[outputDir 'comp'];
mkdir(compPath);

for f=1:nFrames
    
    rp_thisSourceMorphVector = [rp_thisSourceMorphFolder thisSourceMorphFileList(f).name];

%Load source morph vector
Load=load(rp_thisSourceMorphVector);

[imgOut,imgComp]=transfer_func(Load.TPx,Load.TPy,Load.Texture,TM_i,M_j,T,w,h,P_j,caric,compare);

% (3) Affine transform for source morph vector X_if to TX_if

    
    outPath=[outputDir 'frame' num2str(f,'%03i') '.bmp'];
    outMorphPath=[outputDir '\morph\frame' num2str(f) '.mat'];
    
    imwrite(imgOut, outPath,'bmp');
    
    %[TPx,TPy,Texture]=deserialise(R_ifj,w,h);
        %save(outMorphPath,'TPx','TPy','Texture');
    
   
        outPath=[outputDir 'comp\comp' num2str(f,'%03i') '.bmp'];
    
    imwrite(imgComp, outPath,'bmp');
   
end


    videoFromFolder(compPath);


ok=1;
tFin=toc(tStart);
end

