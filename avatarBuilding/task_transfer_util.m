function [ ok,tFin ] = task_transfer_util(h,w,path_targetPCAModel,path_sourceMorphVector,T,TM_i,outputDir,j)

%altixLog(path_sourceMorphVector);
%altixLog('\\kkkkomodo.psyc.this.th\at');
%altixErr(char(string));

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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

transform=0;

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

%Load source morph vector
Load=load(path_sourceMorphVector);
fprintf('Transferring frame %d...\n',j);
%Loads the variables TPx, TPy and Texture

% (3) Affine transform for source morph vector X_if to TX_if
sourceVec = serialise(Load.TPx, Load.TPy, Load.Texture);
if transform
    
TX_if = Affine_Transform(Load.TPx, Load.TPy, Load.Texture, T, w, h);
else
    TX_if=sourceVec;
sourceVec = serialise(Load.TPx, Load.TPy, Load.Texture);
end

% (4) Calculate relative morph vector of source frame
        TR_if = TX_if - TM_i;
    
        % (5) Project to PCA space of target identity, find PCA
        % coefficients
        Q_ifj = P_j' * TR_if;
        
        % (6) Calculate relative morph vector of target identity
        QR_ifj = P_j * Q_ifj;
    
        % (7) Calculate the morph vector of target identity
        R_ifj = QR_ifj + M_j;
    
    IM_ifj = morphvec2image(R_ifj,w,h);
    
    outPath=[outputDir 'frame' num2str(j,'%03i') '.bmp'];
    outMorphPath=[outputDir '\morph\frame' num2str(j) '.mat'];
    
    imwrite(IM_ifj, outPath,'bmp');

    
    [TPx,TPy,Texture]=deserialise(R_ifj,w,h);
        save(outMorphPath,'TPy','TPx','Texture');
    
    
    if compare
        comp=zeros(h,w*2,3);
        comp(:,w+1:w*2,:)=IM_ifj;
        I1=morphvec2image(sourceVec,w,h);
        comp(:,1:w,:)=I1;
        outPath=[outputDir 'comp' num2str(j,'%03i') '.bmp'];
    
    imwrite(comp, outPath,'bmp');
    end

ok=1;
tFin=toc(tStart);
end

