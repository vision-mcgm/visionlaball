function randLoadMat = randpccoefs2face
%% Generates random politicians faces
%
% Q = column vector of PC coefficients (loadings) of face to be recovered
%
% Created by HG 18/02/11

pcspermod = 60; % Dimension of principal components
h = 120;        % Height of images
w = 100;        % Width of images

% Matlab code folder on the cluster
% DirCode = '\\komodo.psychol.ucl.ac.uk\JobData\peng\code\whole1\';
% addpath(DirCode);

% Directory of result of warping, morphing and PCA.
DirMorphing = ...
    'C:\Documents and Settings\Harry\My Documents\Face programming\Politicians faces\Set 7\All_1sts_aligned_ref_Con33_60PCs\';

numFaces = input('Enter number of random faces to produce: ');


caricCoeffPercent = input('Enter % caricaturing coefficient (100 = no change, > 100 = exaggerated expression): ');

caricCoeff = caricCoeffPercent/100;

multiface = input('Do you wish to display antiface and sharpened versions (1 = yes, 0 = no): ');

SDvec = ones(pcspermod,1).*NaN;

% Create sharpening filter
fil = fspecial('unsharp');


% Read in PCA set
load([DirMorphing '\all\PCAModel.mat']);


% Load variances of PC loadings
load([DirMorphing 'variance.mat'])

for m = 1:pcspermod
    
    % Find SD of PC loadings on this PC
    SD = sqrt(variance(m));
    SDvec(m) = SD;
    
end

randLoadMat = ones(pcspermod,numFaces).*NaN;

for n = 1:numFaces
    
    randLoads = ones(pcspermod,1).*NaN;
    
    for p = 1:pcspermod
        
        % Generate values from a normal distribution with mean 1 and standard deviation 2.
        
        randLoads(p) = SDvec(p)*randn;
        
        Q = randLoads;
        
    end
    
    randLoadMat(:,n) = Q;
    
    % (6) Calculate relative morph vector of target identity by
    % multiplying coefficient by PCs
    QR = PCA(:,1:pcspermod) * Q;
    
    % (6a) Caricature relative morph vector of target identity
    QRC = QR*caricCoeff;
    
    % (7) Calculate the morph vector of target identity by adding
    % target mean
    R = MeanMorph + QRC;
    
    % (7a) Calculate (7) Calculate the anti-morph vector of target
    % identity by subtracting mean-relative vector from target mean
    R_inv = MeanMorph - QRC;
    
    % (8) Transform R_ifj to image format
    IM = morphvec2image(R, w, h);
    IM_inv = morphvec2image(R_inv, w, h);
    
    % (9) Sharpen image
    IMS = imfilter(IM,fil, 'replicate');
    IMS_inv = imfilter(IM_inv,fil, 'replicate');
    % 'replicate' 	Input array values outside the bounds of the array
    % are assumed to equal the nearest array border value. Used to try
    % to to prevent the pale border appearing on final images.
    
    
    if multiface == 1
        
        figure
        subplot(2,2,1)
        imshow(IM)
        title(['Random face ' num2str(n) ' x ' num2str(caricCoeffPercent) '%'])
        
        subplot(2,2,2)
        imshow(IMS)
        title('Sharpened')
        
        subplot(2,2,3)
        imshow(IM_inv)
        title('Antiface')
        
        subplot(2,2,4)
        imshow(IMS_inv)
        title('Antiface sharpened')
        
    elseif multiface == 0
        
%         figure;
        
%                  imshow(IM)
%         imshow(IMS)
        
        
    end
    
end

end %of function