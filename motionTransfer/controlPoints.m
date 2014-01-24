function [  ] = s1a_ControlPoints( c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Created by HG 04/06/10 to extract means from PCA files for manual
% location of control points

% runCPtool = input('Do you want to manually locate new control points? (1 = Yes, 0 = No): ');
% showCPs = input('Do you want to show control points overlaid on morph means? (1 = Yes, 0 = No): ');


runCPtool = 1;
showCPs = 1;


% Matlab code folder on the cluster
%dirCode = config.dirCode; %NB check capital 'K' or not
%addpath(rightPath(c,dirCode));

h = c.h;
w = c.w;
nummod = c.models;

MorphMeansOut = zeros(h,w,3,nummod).*NaN;
% MeanOfMorphsOut = zeros(h,w,3,nummod).*NaN;

% Directory of result of warping, morphing and PCA...


%c1=readConfig(rightPath(c,c.sourceConf));
%c2=readConfig(rightPath(c,c.targetConf));

c1=config(c.sourceConf);
c2=config(c.targetConf);

% Load existing cps
% load('\\komodo.psychol.ucl.ac.uk\JobData\rs\test\morphing 120 X 100\cpstack_all_1_36.mat')


% matIndex = 0;
% 
% for i = 2  % Identity - source sequence - (a)
%     
%     fprintf('Reading morph mean from PCAModel of model %d\n', i)
%     
%     %     IndexIdentityI = i;
%     IndexIdentityI = i+2;
%     
%     % Create independent indxer for output matrix to avoid empty planes at
%     % front of output matrix
%     matIndex = round(matIndex+1);
%     
%     % Prefix of the image folder
%     %     FileOriginalImage = ['Input_' num2str(IndexIdentityI)];
%     
%     % Folder of morph vector for this identity
%     %     DirMorphingI = [DirMorphing FileOriginalImage '\'];
%     DirMorphingI = [DirMorphing 'Model_' num2str(i) '\'];
%     
%     % [1] Get mean morph vector M_i
%     DirAllI =  [DirMorphingI 'all\'];
%     
%     % Load mean image from all morph vectors
%     %     MorphModelFile = [DirAllI 'MorphVectors.mat']; % Filename of PCA model
%     %     load(MorphModelFile)
%     %     MeanOfMorphs = mean(Data,2);
%     %     out1 = morphvec2image(MeanOfMorphs,100,120);
%     %     MeanOfMorphsOut(:,:,:,matIndex) = out1;
%     
%     % Load mean image from PCAModel
%     %     PCAModelFile = [DirAllI 'PCAModel.mat']; % Filename of PCA model
%     %     load(PCAModelFile, 'MeanMorph');
%     load([DirAllI 'MorphMean.mat'])
%     out2 = morphvec2image(MorphMean,w,h);
%     MorphMeansOut(:,:,:,matIndex) = out2;
%     
% end

load([rightPath(c1,c1.dirPCAModel) 'all\MorphMean.mat']);
out2 = morphvec2image(c1,MorphMean);
MorphMeansOut(:,:,:,1) = out2;
clear MorphMean

load([rightPath(c2,c2.dirPCAModel) 'all\MorphMean.mat']);
out2 = morphvec2image(c2,MorphMean);
MorphMeansOut(:,:,:,2) = out2;
clear MorphMean


%% Compare means in image

% AllImDiffs = zeros(120,100,3,16).*NaN;
%
% matIndex = 0;
%
% for k = 1:nummod
%
%     matIndex = matIndex + 1;
%
%     im_MoMO =  squeeze(MeanOfMorphsOut(:,:,:,k));
%     im_MMO =  squeeze(MorphMeansOut(:,:,:,k));
%
%     AllImDiffs(:,:,:,matIndex) = im_MoMO - im_MMO;
%
%     ImDiff = squeeze(im_MoMO - im_MMO);
%
%     figure;
%
%     subplot(1,3,1); imshow(im_MoMO)
%     subplot(1,3,2); imshow(im_MMO)
%     subplot(1,3,3); imshow(ImDiff+0.5)
%
% end

%% Run CP tool to manually identify control points


%This bit has been modified to just save the CPs for the current model
if runCPtool == 1;
    
    %cpstack = ones(4,2,nummod).*NaN;
    
    for i = 1:nummod;
        
        % Taking images from Mean Morph as loaded from PCAModel.mat
        im1 =  squeeze(MorphMeansOut(:,:,:,(1)));
        im2 = squeeze(MorphMeansOut(:,:,:,(2)));
        
        
        
        %         % Taking images from mean as extracted from PCAModels
        %         im1 =  squeeze(MeansOut(:,:,:,(2*i-1)));
        %         im2 = squeeze(MeansOut(:,:,:,(2*i)));
        
        [first_points, second_points] = cpselect(im1,im2, 'Wait', true);
        
        cpstack(:,:,2*i-1) = first_points;
        cpstack(:,:,2*i) = second_points;
    end
    
    save(rightPath(c, c.keypoints), 'cpstack')
end


% Plot mean faces with control points superimposed

if showCPs == 1;
    
    
    fprintf('Plotting morph means and CPs\n\n')
    
    for i = 1:2  % Identity - source sequence - (a)
        subplot(4,2,i);
        hold on
        
        imshow(MorphMeansOut(:,:,:,i));
        title(i);
        
        for j = 1:4
            scatter(cpstack(j,1,i), cpstack(j,2,i));
        end
        
    end
    
end
figure(1)
close
end



