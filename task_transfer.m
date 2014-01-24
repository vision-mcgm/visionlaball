function [ ok,tFin ] = task_transfer(c,j,T,TM_i,morphVecFiles,caric,c1,c2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%C: transfer config
% TM_i: morph vector of source frame
tStart=tic;
h=c.h;
w=c.w;



compare=1;

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
 
%Load source morph vector
Load=load([rightPath(c1,c1.dirPCAModel) 'morph\' morphVecFiles(j).name]);
fprintf('Transferring frame %d...\n',j);
%Loads the variables TPx, TPy and Texture

%altixLog([path which('transfer_func')]);

[imgOut,imgComp]=transfer_func(Load.TPx,Load.TPy,Load.Texture,TM_i,M_j,T,w,h,P_j,caric,compare);

imwrite(imgOut, [rightPath(c,c.dirOutput) 'frame' num2str(j,'%03i') '.bmp'],'bmp');
outPath=[rightPath(c,c.dirOutput) 'comp\comp' num2str(j,'%03i') '.bmp'];
imwrite(imgComp, outPath,'bmp');
ok=1;
tFin=toc(tStart);
end

