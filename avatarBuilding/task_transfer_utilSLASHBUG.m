function [ ok,tFin ] = task_transfer_util(string)%(h,w,path_targetPCAModel,path_sourceMorphVector,T,TM_i,outputDir,j)

altixErr(string);
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
TX_if = Affine_Transform(Load.TPx, Load.TPy, Load.Texture, T, w, h);


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
    
    imwrite(IM_ifj, outPath,'bmp');

ok=1;
tFin=toc(tStart);
end

