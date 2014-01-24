function [ x,y ] = warp_util(target,ref)
%THIS IS THE DEFINITIVE VERSION OF THE MCGM WARP ALG - EVRYONE SHOULD BE CALLING
%THIS.
%Input: target and reference images, uint8s [0-255]
%Accepts monochrome images too
%Output: x and y components of warp field between two images
%By F Nagle, mostly modified from Harry and Peng and Glyn
%April 2012

% Set parameters of McGM

mcgmcpp = 1.5;
mcgmconv = 23;
mcgmthresh = 0.1;
nIts = 50;
G=Gaussian(1.5,23);
[sy sx sc]=size(target);

% load and filter reference image
ref=double(ref);
rec=ref;
target=double(target);
%Handle colour or black and white images - conv to gray
if sc==3
    ref2=conv2(conv2(rgb2gray(ref/255),G,'same'), G','same');
    target2=conv2(conv2(rgb2gray(target/255), G, 'same'), G', 'same');
else
    ref2=conv2(conv2(ref/255,G,'same'), G','same');
    target2=conv2(conv2(target/255, G, 'same'), G', 'same');
end

[h w]=size(ref2);
[X Y]=meshgrid(1:w,1:h);
prevWx=zeros(h, w);
prevWy=zeros(h, w);

%     Warp at different scales for different size images...
if w<=100
    %cswarp does several warps and merges them
    [Wx, Wy] = cswarp(ref2, target2, [0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
    ... or for 240 x200
elseif w<=200
    [Wx, Wy] = cswarp(ref2, target2, [0.05, 0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
else
    [Wx, Wy] = cswarp(ref2, target2, [0.05, 0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
end

% warp from previous est...(DEPRECATED COMMENT)
if sc==3
    rec2=conv2(conv2(rgb2gray(rec/255), G, 'same'), G', 'same');
else
    rec2=conv2(conv2(rec/255, G, 'same'), G', 'same');
end
%Check we're not too small to segfault the MCGM

[shot vel angles]=mcgm2(rec2, target2, mcgmcpp, mcgmconv, mcgmthresh);

%Convert from vel/ang to vectors
[Ux Uy]=out2vecs(vel, angles);
%Get rid of NaNs
Ux(isnan(Ux))=0;
Uy(isnan(Uy))=0;
% concatenate onto previous flow field(DEPRECATED COMMENT)
Vx=Ux+interp2(prevWx, X-Ux, Y-Uy);
Vx(isnan(Vx))=prevWx(isnan(Vx));
Vy=Uy+interp2(prevWy, X-Ux, Y-Uy);
Vy(isnan(Vy))=prevWy(isnan(Vy));
for j=1:nIts,
    [Vx, Vy]=refine(abs(ref2), Vx, Vy, 3);
end
% Warp the reference with the calculated warp field and compare it to the
% target.
if sc==3
    err1 = sum((rgbinterp2(ref, X-Wx, Y-Wy)-target).^2, 3); 
    err2 = sum((rgbinterp2(ref, X-Vx, Y-Vy)-target).^2, 3);
else
    err1 = sum((interp2(ref, X-Wx, Y-Wy)-target).^2, 3);
    err2 = sum((interp2(ref, X-Vx, Y-Vy)-target).^2, 3);
end
%Convolve the error with a filter (I think this smooths but don't count on
%it)
err1 = conv2(err1, ones(3)/9, 'same');
err2 = conv2(err2, ones(3)/9, 'same');
%Init weights to a half
w1 = repmat(1/2, h, w);
w2 = repmat(1/2, h, w);
den = err1+err2;
%Where error is above zero, alter the weight matrix depending on the error
w1(den~=0) = err2(den~=0)./den(den~=0);
w2(den~=0) = err1(den~=0)./den(den~=0);
%Alter the result depending on the weights
prevWx = (w1.*Wx) + (w2.*Vx); prevWx(isnan(prevWx)) = 0;
prevWy = (w1.*Wy) + (w2.*Vy); prevWy(isnan(prevWy)) = 0;
x = prevWx;
y = prevWy;

end

% Functions ------------------------------------------------------------------

% cswarp function - motion compare a pair of images across several scales
function [Wx, Wy] = cswarp(ref, target, scales, mcgmcpp, mcgmconv, mcgmthresh, nIts)
rec = ref;
% figure; imshow(k*ref);
[h w p] = size(ref);
[X Y] = meshgrid(1:w, 1:h);
Wx = zeros(h, w);
Wy = zeros(h, w);
for i = 1:size(scales, 2),
    %Loop over different image scales
    neww = round(w*scales(i));
    newh = round(h*scales(i));
    
    srec = imresize(rec, [newh neww], 'bilinear');
    starget = imresize(target,  [newh neww], 'bilinear');
    
    %Pad the images so that we don't get border effects
    paddedrec = [zeros(mcgmconv, neww+(2*mcgmconv)); zeros(newh, mcgmconv) srec zeros(newh, mcgmconv); zeros(mcgmconv, neww+(2*mcgmconv))];
    paddedtarget = [zeros(mcgmconv, neww+(2*mcgmconv)); zeros(newh, mcgmconv) starget zeros(newh, mcgmconv); zeros(mcgmconv, neww+(2*mcgmconv))];
    fprintf('Doing mcgm on imgs of size %d,%d\n',size(paddedrec,1), size(paddedrec,2));
    %Do mcgm
    [shot vel angles] = mcgm2(paddedrec, paddedtarget, mcgmcpp, mcgmconv, mcgmthresh);
    %Convert to vector representation
    [Vx Vy] = out2vecs(vel, angles);
    mainVx = Vx(mcgmconv+1:mcgmconv+newh, mcgmconv+1:mcgmconv+neww);
    mainVy = Vy(mcgmconv+1:mcgmconv+newh, mcgmconv+1:mcgmconv+neww);
    W = abs(conv2(srec, [-1, -1, -1; -1, 8, -1; -1, -1, -1], 'same'));
    for j=1:nIts,
        [mainVx, mainVy] = refine(W, mainVx, mainVy, 3);
    end
    %Resize and interpolate images
    fullVx = imresize(mainVx/scales(i), [h w], 'bilinear');
    fullVy = imresize(mainVy/scales(i), [h w], 'bilinear');
    catVx = fullVx+interp2(Wx, X-fullVx, Y-fullVy); catVx(isnan(catVx)) = Wx(isnan(catVx));
    catVy = fullVy+interp2(Wy, X-fullVx, Y-fullVy); catVy(isnan(catVy)) = Wy(isnan(catVy));
    Wx = catVx; Wy = catVy;
    rec = interp2(ref, X-Wx, Y-Wy);
end
end

% Rgb version of interp2- written when glyn got sick of typing this for the millionth time
function rec = rgbinterp2(pic, U, V)
rec=cat(3, interp2(pic(:,:,1),U,V),interp2(pic(:,:,2),U,V),interp2(pic(:,:,3),U,V));
end

%Make a Gaussian distribution
function G=Gaussian(sigma,size)
x=(-(size-1)/2) : ((size-1)/2);
G=(1/sqrt(4*sigma*pi))*exp(-(x.^2)/(4*sigma));
end

%Convert ang/vel representation to x/y
function [Vx, Vy]=out2vecs(vel,angles)
Vx=vel.*sin(angles*pi/180);
Vy=vel.*cos(angles*pi/180);
end

%I don't know what this function does.
function [Wx, Wy] = refine(W, Vx, Vy, rsize)
radius=floor(rsize/2);
[h w]=size(W);
Wx=zeros(h,w);
Wy=zeros(h,w);
total=zeros(h,w);
for xshift=-radius:rsize-radius-1,
    for yshift=-radius:rsize-radius-1,
        if xshift<1
            xstart = 1;
            xend = w+xshift;
        else
            xstart = 1+xshift;
            xend = w;
        end
        if yshift<1
            ystart = 1;
            yend = h+yshift;
        else
            ystart = 1+yshift;
            yend = h;
        end
        Wx(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift)=Wx(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift) + (W(ystart:yend,xstart:xend).*Vx(ystart:yend,xstart:xend));
        Wy(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift)=Wy(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift) + (W(ystart:yend,xstart:xend).*Vy(ystart:yend,xstart:xend));
        total(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift)=total(ystart-yshift:yend-yshift,xstart-xshift:xend-xshift) + W(ystart:yend,xstart:xend);
    end
end
testdiv=(total~=0);
Wx(testdiv)=Wx(testdiv)./total(testdiv);
Wy(testdiv)=Wy(testdiv)./total(testdiv);
Wx(~testdiv)=Wx(~testdiv)/(rsize*rsize);
Wy(~testdiv)=Wy(~testdiv)/(rsize*rsize);
end