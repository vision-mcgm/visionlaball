function [ ] = s0_resize (config)% Script for resizing original video images

removeBackground=1;

outputFolderSwitch = input('Enter 1 to output to dirResizedBitmaps (for further processing), 2 to output to dirSourceBitmaps (to go directly to PCA-building).\n');

c=config;
disp('WARNING:this does cropping too!');
% Created by Harry Griffin
% Date 24/06/10

%  matlabpool 10

% AllIms = input('Resize all frames in input folder (1 = Yes, 2 = manually enter number of frames): ');

% if AllIms == 2
%     ManNumIms = input('Enter number of frames tio be resized: ');
% end

NumMod = 36;
% Vertical and horizontal size to resize to (pixels)
VSize = config.h;
HSize = config.w;

% Matlab code folder on the cluster
DirCode = rightPath(config, config.dirCode); %NB THIS CHANGED by HG 04/06/10
addpath(DirCode);

% DirMods = 'I:\Video capture backup 30_09_09\Video Capture\Appearance of faces _ Opposites attract\Video data\UCL dynamic expressive sequences\';
DirMods = rightPath(config,config.dirSourceBitmaps);

% IdVec = {'AD'; 'AE'; 'AO'; 'AS'; 'AT'; 'AU'; 'AV'; 'AW';...
%     'AY'; 'AZ'; 'BB'; 'BC'; 'BD'; 'BF'; 'BG'; 'BJ'; 'BO'; 'BP';...
%     'BQ'; 'AG'; 'AH'; 'AI'; 'AJ'; 'AL'; 'AN'; 'AB'; 'AC';...
%     'AM'; 'BI'; 'BV'; 'BX'; 'CE'; 'CG'; 'CI'; 'CJ'; 'CL'};

% Establish first image to be converted for each image (currently set as
% 1st image in folder
StartingIm = ones(34,1);

% This line here only for clever parfor version, otherwise uncomment the if
% loop in lines60-64
NumIms = config.frames; %ManNumIms;
frames=config.frames;
models=config.models;


% This sectino an attempt to use clever parfor loop in order to speed
% things up, not working!
%  parfor k = 1 : NumMod * NumIms
%
%      b1(k) = ceil(k / NumIms); % Working model
%
%      c1(k) = rem(k, NumIms); % Working Image
%
%         if ~ c1(k)
%             c1(k) = NumIms;
%         end
%
%         i = b1(k); % Index of Model
%         j = c1(k); % Index of Image


    tStartMain1 = clock;
    
    %     IdentityModI = IdVec{i};
    
    %     Folder for input images
    %     DirModI = [DirMods IdentityModI '\Rotated\' IdentityModI '_hatless\'];
    %     DirModI = [DirMods 'Input_' num2str(i) '\'];
    DirModI = rightPath(config,config.dirBitmapsBeforeResize);
    
    F = dir([DirModI '*.bmp']);
    
    %     This section used to establish number of bmps in the various source
    %     folders
    %     SizeI = size(F);
    %     SizeI = SizeI(1);
    %     SizeAll(i,1) = SizeI; % returns vector with number of images in each
    % %     folder
    %     last{i,1} = F(Size1).name; % Returns cell (vector) with name of last
    % %     image in each folder (should be xxx300.bmp This could be changed to
    % %     F(n).name to give the name of the nth image in each folder
    % end
    
    % This section used to apply automatic or manually entered number of frames
    % to be converted
    %     if AllIms ==1
    %         NumIms = size(F, 1);
    %     elseif AllIms == 2
    %         NumIms = ManNumIms;
    %     end
    
    %     Output folder for this model
    %     DirOut = '\\komodo.psychol.ucl.ac.uk\JobData\rs\test\large_originals\';
    %     DirOut = '\\komodo.psychol.ucl.ac.uk\JobData\rs\test\small_originals\';
    %     DirOutMod = [DirOut 'Input_' num2str(i) '\'];
    if outputFolderSwitch == 2
    DirOutMod = rightPath(config,config.dirSourceBitmaps); %% REMOVE THIS
    else
        DirOutMod=rightPath(config,config.dirResizedBitmaps);
    end
    
    if ~isdir([DirOutMod])
    mkdir([DirOutMod]);
end
    sourceDir=rightPath(c,c.dirBitmapsBeforeResize);
    % Create output folder if unavailable.
    
    
    %     Find first image to be resized for this model
    %     WorkImRef = StartingIm(i);
   
    
    %These are top-right-rel x-y coords. So are normal Matlab image coords.
    imref=imread([sourceDir F(1).name]);
    imshow(imref);
    h=imrect(gca,[10 10 100 120]);
    h.setFixedAspectRatioMode(true);
    position=wait(h);
    
    position=round(position);
    
    
    for j = 1:frames
        WorkImRef=1;
        fprintf('Model = %d, Frame = %d (of %d) source frame = %d\n', i, j, NumIms, WorkImRef);
        
      
        
        
        
        ImageName = autoConv(config,[rightPath(config,config.dirBitmapsBeforeResize) F(j).name]);
        ImageNameOut = autoConv(config,[DirOutMod  F(j).name]); % Using this line reads 300 images from the starting image defined in WorkImRef
        %         ImageName = [DirModI F(j).name]; % Using this line automatically reads images 1-300
        
        % Read image
        WorkIm = imread(ImageName);
        n=100;
        p=position;
        WorkIm=WorkIm(p(2):p(2)+p(4),p(1):p(1)+p(3),:);
        
          if i ~=1
            
            
            
          end
        
        lastIm=WorkIm;
          
        % Crop image
        %         TrimIm = WorkIm(31:720, 2:576, :);
        
        % Resize
        %         NewIm = imresize(TrimIm, [VSize HSize]);
        
        % Resize without trimming
        NewIm = imresize(WorkIm, [VSize HSize]);
        
        % Write image
        
        switch floor(log10(j))
            
            case 0
                FilePathName = [DirOutMod,'driver00',int2str(j),'.bmp'];
            case 1
                FilePathName = [DirOutMod,'driver0',int2str(j),'.bmp'];
            case 2
                FilePathName = [DirOutMod,'driver',int2str(j),'.bmp'];
        end
        
        % Save new image
        %         SaveImg2BMPFile(FilePathName, NewIm);
        SaveImg2BMPFile(ImageNameOut, NewIm);
        
        % Advance image reference by one
        
        
    end
    
    fprintf('Resizing %d frames of model %d takes %4.2f seconds.\n', ...
        NumIms, i, etime(clock, tStartMain1));

end
