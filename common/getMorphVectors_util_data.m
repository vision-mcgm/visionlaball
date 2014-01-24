function [ TVx,TVy,T_img,Mx,My,Mtex ] = getMorphVectors_util_data(TVx,TVy,T_img,rMx,rMy )
%Makes mean-relative morph vectors out of warp fields, mean warp and
%reverse warp, and textures.
%Args: time-indexed warp field matrixes (indexed (time,rows,cols) and textures, and
%reverse mean flow fields (indexed rows,cols) and textures.

%ALSO CALCULATES THE MEAN!

nFrames=size(TVx,1);
mask0 = []; %Brought in from the previous file. It's null

im=squeeze(T_img(1,:,:,:));
    
     [h w p] = size(im);

Mx=zeros(h,w);
My=zeros(h,w);
Mtex=zeros(h,w,p);


for i=1:nFrames
    
    im=squeeze(T_img(i,:,:,:));
    
     [h w p] = size(im);
    [X Y] = meshgrid(1:w, 1:h);
    
    if isempty(mask0)
        mask = ones(h, w);
    else
        mask = mask0;
    end
    
    Wx=squeeze(TVx(i,:,:));
    Wy=squeeze(TVy(i,:,:)); %Isolate warp fields to the reference image
    tex=squeeze(T_img(i,:,:,:));
    
    
    
    
    %120 by 100
        Wx = conv2(conv2(Wx, Gaussian(1.5, 23), 'same'), Gaussian(1.5, 23)', 'same');
    Wy = conv2(conv2(Wy, Gaussian(1.5, 23), 'same'), Gaussian(1.5, 23)', 'same');
    
    % For 240 x 200 pixel images
%     Wx = conv2(conv2(Wx, Gaussian(3, 46), 'same'), Gaussian(3, 46)', 'same');
%     Wy = conv2(conv2(Wy, Gaussian(3, 46), 'same'), Gaussian(3, 46)', 'same');
    
    % adjust flow field to point to mean    
    Vx = Wx + interp2(rMx, X-Wx, Y-Wy); Vx(isnan(Vx))=0;
    Vy = Wy + interp2(rMy, X-Wx, Y-Wy); Vy(isnan(Vy))=0;
    
     [rVx, rVy] = invertflowfield(Vx, Vy);
    Px = X-rVx; Px(Px<1) = 1; Px(Px>w) = w;
    Py = Y-rVy; Py(Py<1) = 1; Py(Py>h) = h;
    rec = rgbinterp2(im, Px, Py); rec(isnan(rec)) = 0;
    rec = rec.*cat(3, mask, mask, mask);
    Px = X-Vx-1; Px(Px<0) = 0; Px(Px>w-1) = w-1; Px(isnan(Px)) = X(isnan(Px));
    Py = Y-Vy-1; Py(Py<0) = 0; Py(Py>h-1) = h-1; Py(isnan(Py)) = Y(isnan(Py));
    
    TVx(i,:,:)=Px;
    TVy(i,:,:)=Py;
    
    Mx=Mx+Px;
    My=My+Py;
    
    
    
    T_img(i,:,:,:)=rec;
    Mtex=Mtex+rec;
    
end

 Mx = (Mx / nFrames)+1; 
    My = (My / nFrames)+1;
    Mtex = Mtex / nFrames; %Don't know why the +1, from legacy script by Harry Griffin

end




% Load File inside Parfor loop
function [TWx, TWy] = LoadFromFileMat(FilePath, FileName)
load([FilePath FileName], 'TWx', 'TWy');
end

% Load mean flow field inside Parfor loop
function [rMx, rMy] = LoadFromFileMatMFF(MeanFFieldFile)
load(MeanFFieldFile, 'rMx', 'rMy');
end

% Save File inside Parfor loop
function Save2FileMat(FilePath, FileName, TPx, TPy, Texture)
save([FilePath FileName], 'TPx', 'TPy', 'Texture');
end

% function G=Gaussian(sigma,size)
function G=Gaussian(sigma,size)
x = (-(size-1)/2) : ((size-1)/2);
G = (1/sqrt(4*sigma*pi))*exp(-(x.^2)/(4*sigma));
end

% Calculate inverse flow field given a flow field
% The original code somtimes reports a qhull precision error when using
% griddata function. Here the data are rescled before the preprocessing.
% May need to adapt to the data in the future!!!
%
% Peng Li 25-03-2010
function [rVx, rVy] = invertflowfield(Vx, Vy)
[h w] = size(Vx);
[X Y] = meshgrid(1:w, 1:h);

S = 1e2; % Scale factor - may need to adapt to different data (Peng)

rVx = griddata((X-Vx) ./ S, (Y-Vy) ./ S, -Vx ./ S, X ./ S, Y ./ S); 
rVx = rVx .* S;
rVx(isnan(rVx)) = 0;

rVy = griddata((X-Vx) ./ S, (Y-Vy) ./ S, -Vy ./ S, X ./ S, Y ./ S);  
rVy = rVy .* S;
rVy(isnan(rVy)) = 0;
end

% Rgb version of interp2- written when glyn got sick of typing this for the millionth time
function rec = rgbinterp2(pic, U, V)
rec = cat(3, interp2(pic(:,:,1), U, V), interp2(pic(:,:,2), U, V), interp2(pic(:,:,3), U, V));
end