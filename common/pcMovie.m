 function M=pcMovie(c)
% function M=morphpcmoviesine(avfilename, viewmatrix, sds, N)
%   viewmatrix: matrix containing indices of pcs in arrangement for
%       viewing e.g., viewmatrix = reshape(1:15, 5, 3)'
%   sds: number of standard deviations from mean to animate
%   N: number of frames
% Makes a movie, M, animating the basis set in the PCAModel.mat file

% [variance, minmax, w, h, mu, basis] = avfread(avfilename);
% amended by FB, 31.10.2006

% Default values when not running as a function

%Params
viewmatrix = reshape(1:15, 5, 3)'; % Shows first 15 PCs
sds = 2; % Animates 2 SDs
N = 50; % shows 25 frames

scaling=0.5;

%Work
h = c.h;
w = c.w;


rootDir = locPath(c,c.dirPCAModel);

load([rootDir 'all\PCAModel.mat'], 'PCA', 'MorphMean'); %BEWARE THIS MAY BREAK

%yetVars = input('Enter location of variance file or "0" to compute variances: ');

    
%     morphDir = ([rootDir 'morph\']);
%     
%     F = dir([morphDir '*.mat']);
%     
%     numIms = size(F,1);
%     
%     varMat = ones(numIms,size(PCA,2)).*NaN;
%     
%     Vec = zeros(60000,1);
%     
%     for q = 1:numIms
%         fprintf('Calculating PCA coefficients for image %d (%s) of %d\n', q, F(q).name, numIms);
%         pcMovie
%         load([morphDir F(q).name], 'TPx', 'TPy', 'Texture');
%         
% %         Vec = data2morphvec(TPx, TPy, Texture); This function contains a
% %         "-1" term which is not in the line below 
%         Vec = [TPx(:)', TPy(:)', Texture(:)']'; % This returns proper results 
%         % with zero-centred distibutions of loadings around the MeanMorph
%         % and decreasing variance for each PC
%         
%         relVec = Vec - MeanMorph;
%         
%         pccoefs = relVec' * PCA;
%         
%         varMat(q,:) = pccoefs;
%         
%     end
%     
%     variance = var(varMat)';
%     
%     save([rootDir 'pccoefs.mat'], 'varMat');
%     save([rootDir 'variance.mat'], 'variance');
%     

load([rootDir 'all\variance.mat']);
load([rootDir 'all\MorphMean.mat']);
MeanMorph=MorphMean;


pic = zeros(size(viewmatrix,1)*h, size(viewmatrix,2)*w, 3);

a = sin([0:N-1]*pi*2/N);

for i=1:N,
    fprintf('Creating movie frame %d\n', i)
    
    k = a(i);
    for rows = 1:size(viewmatrix,1),
        for cols = 1:size(viewmatrix,2),
            pc = viewmatrix(rows,cols);
            % HG 26/10/10 what is the "/(length(variance)-1)" for? Is this
            % an attempt to code in SEM? in which case it should be
            % "/numIms-1"
%             This may be correct since variance is read from the avf file,
%             which stores 'evals' (eigenvalues) which are not quite the
%             same as variances. Eigenvalues may be related to the number
%             of PCs, hence the correction.
            %              vec = MeanMorph + (k*sds*sqrt(variance(pc)/(length(variance)-1))*PCA(:, pc));
            
            
            % Simpler, but possibly wrong formula
            vec = MeanMorph + (k*sds*sqrt(variance(pc))*PCA(:,pc));
            %             [Px, Py, tex] = morphvec2data(vec, w, h);
            %             Px(Px<1)=1; Px(Px>w)=w; Py(Py<1)=1; Py(Py>h)=h;
            thisIm= morphvec2image(vec, w, h).*255;
          %  imwrite(thisIm,['C:\Users\Alan Admin\Desktop\samples\' num2str(i)],'bmp');
            pic(((rows-1)*h)+1:rows*h, ((cols-1)*w)+1:cols*w, :) =thisIm;
        end
    end
    pic(pic>255) = 255; pic(pic<0) = 0;
    %     imshow(pic/255);
    %     M(i) = getframe;
    M(i).cdata = imresize(uint8(pic),scaling);
    M(i).colormap = [];
    %     M(i).cdata = uint8(pic);
    %     M(i).colormap = gray;
end

fprintf('Making video...\n')
movie2avi(M, [rootDir 'PCmovie_2_SDs.avi'], 'fps', 25, 'compression', 'none');
 end
