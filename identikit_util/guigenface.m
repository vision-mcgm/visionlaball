function [o]=guigenface(Input,antiface)

global c;
global myVars;

if size(Input,2)~=1
    Input=Input';
end


%% Shows face corresponding to inputted PC coefficients
%
% Q = column vector of PC coefficients (loadings) of face to be recovered
%
% Created by HG 18/02/11

% pcspermod = 50; % Dimension of principal components
% h = 120;        % Height of images
% w = 100;        % Width of images
h=c.h
w=c.w
% Matlab code folder on the cluster
% DirCode = '\\komodo.psychol.ucl.ac.uk\JobData\peng\code\whole1\';
% addpath(DirCode);

% Directory of result of warping, morphing and PCA.
%DirMorphing = ...
    '/Network/Servers/xgrid.complex.ucl.ac.uk/Volumes/Users/fintannagle/bc/vision/matlab/gui/';
    DirMorphing ='';

caricCoeffPercent = 100;

caricCoeff = caricCoeffPercent/100;



% randGen = input('Do you wish to generate a random face? (1 = Yes, 0 = No): ');
% 
% if randGen == 1
%
%     randLoads = ones(pcspermod,1).*NaN;
%         SDvec = ones(pcspermod,1).*NaN;
%
%
%     % Load variances of PC loadings
%     load([DirMorphing 'variance.mat'])
%
%     for p = 1:pcspermod
%
%         % Find SD of PC loadings on this PC
%         SD = sqrt(variance(p));
%         SDvec(p) = SD;
%
%         % Generate values from a normal distribution with mean 1 and standard deviation 2.
%
%         randLoads(p) = 0 + SD.*randn(1);
%
%         Q = randLoads;
%     end
%
% elseif randGen == 0
% 
global myVars;
Q = Input(1:myVars.PCAsize,:);
%
% end

% Create sharpening filter
fil = fspecial('unsharp');
global gLoadedM;
global gPCAM;
global gMeanMorphM;
global gMultiplier;
global gStddevsM;
global silly;

multiplier=silly;%this sets the caricaturing coeff.
% Read in PCA set for avatar


%Turn slider coeff into PCA coeffs

Q= Q*2;
Q=Q-1;

try
Q=Q.*(gStddevsM);
catch
    Q=Q.*(gStddevsM');
end

Q=Q*multiplier







% (6) Calculate relative morph vector of target identity by
% multiplying coefficient by PCs

QRC = gPCAM * Q;




% (7) Calculate the morph vector of target identity by adding
% target mean
R = gMeanMorphM + QRC;

% (7a) Calculate (7) Calculate the anti-morph vector of target
% identity by subtracting mean-relative vector from target mean
R_inv = gMeanMorphM - QRC;
if myVars.displayMode==3
% (8) Transform R_ifj to image format
IM = morphvec2image_kit(R, w, h);
IM_inv = morphvec2image_kit(R_inv, w, h);

% (9) Sharpen image
IMS = imfilter(IM,fil, 'replicate');
IMS_inv = imfilter(IM_inv,fil, 'replicate');
% 'replicate' 	Input array values outside the bounds of the array
% are assumed to equal the nearest array border value. Used to try
% to to prevent the pale border appearing on final images.

o=IM;

elseif myVars.displayMode==2
    %Warp
    [Qx Qy Texture] = deserialise(R,w,h);
    image=zeros(h,w);
    
    baseX=repmat(1:w,h,1);
baseY=repmat((1:h)',1,w);
QxR=Qx-baseX;
QyR=Qy-baseY;
    picflow(image,QxR,QyR,2);
    
elseif myVars.displayMode==1
    %Texture
    [Wx,Wy,Texture]=deserialise(R,w,h);
    o=imScale(Texture);
end

myVars.face=o;

end % of function