function [o]=guigenface(Input,antiface)
%% Shows face corresponding to inputted PC coefficients
if size(Input,2)~=1
    Input=Input';
end
% Q = column vector of PC coefficients (loadings) of face to be recovered
%
% Created by HG 18/02/11

% pcspermod = 50; % Dimension of principal components
% h = 120;        % Height of images
% w = 100;        % Width of images
h=120;
w=100;
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
Q = Input;
%
% end

% Create sharpening filter
fil = fspecial('unsharp');
global gLoadedF;
global gPCAF;
global gMeanMorphF;
global gMultiplier;
global gStddevsF;
global gVariancesF;
multiplier=2; %this sets the caricaturing coeff.
% Read in PCA set for avatar
global silly;
multiplier=silly;

%Turn slider coeff into PCA coeffs


Q=Q*multiplier;





% (6) Calculate relative morph vector of target identity by
% multiplying coefficient by PCs

QR = gPCAF * Q;

% (6a) Caricature relative morph vector of target identity
QRC = QR*caricCoeff;

% (7) Calculate the morph vector of target identity by adding
% target mean
R = gMeanMorphF + QRC;

% (7a) Calculate (7) Calculate the anti-morph vector of target
% identity by subtracting mean-relative vector from target mean
R_inv = gMeanMorphF - QRC;

% (8) Transform R_ifj to image format
IM = morphvec2image(R, w, h);
IM_inv = morphvec2image(R_inv, w, h);

% (9) Sharpen image
IMS = imfilter(IM,fil, 'replicate');
IMS_inv = imfilter(IM_inv,fil, 'replicate');
% 'replicate' 	Input array values outside the bounds of the array
% are assumed to equal the nearest array border value. Used to try
% to to prevent the pale border appearing on final images.


o=IM;

end % of function