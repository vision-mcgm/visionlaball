function [ok,tFin] = task_getMorph(frameName,meanFFieldFile,n,nFrames,warpDir,morphDir)
	%Warp images
	tStart=tic;
	
	% Config settings.
	
	PCs=50;
	p=3;
	h=120
	w=100
	ok=0;
	mask0=[];
    
	datFile=['morph' num2str(n) '.mat'];
	
	load(meanFFieldFile);
	im=double(imread(frameName));
	[h w p]=size(im);
	[X Y]=meshgrid(1:w,1:h);
	if isempty(mask0)
		mask=ones(h, w);
    else
		mask=mask0;
    end

    warpFile=[warpDir '\warp' num2str(n,'%03d') '.mat'];
	load(warpFile);
   	Wx=TWx;
    Wy=TWy;
    Wx=conv2(conv2(Wx,Gaussian(1.5,23),'same'),Gaussian(1.5,23)','same');
    Wy=conv2(conv2(Wy,Gaussian(1.5,23),'same'),Gaussian(1.5,23)','same');

    % For 240 x 200 pixel images
    %Wx=conv2(conv2(Wx,Gaussian(3,46),'same'),Gaussian(3,46)','same');
    %Wy=conv2(conv2(Wy,Gaussian(3,46),'same'),Gaussian(3,46)','same');

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
    TPx=Px;
    TPy=Py;
    Texture=rec;

    prec=ceil(log10(nFrames));
    format=['%.' num2str(prec) 'i'];
    save([morphDir '\morph' num2str(n,format) '.mat'],'TPx', 'TPy', 'Texture');
    ok=1;
    tFin=toc(tStart);
end

function G=Gaussian(sigma,size)
	x=(-(size-1)/2) : ((size-1)/2);
	G=(1/sqrt(4*sigma*pi))*exp(-(x.^2)/(4*sigma));
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
function rec = rgbinterp2(pic,U,V)
%Handle black and white images too
if size(pic,3)==3
	rec=cat(3,interp2(pic(:,:,1),U,V),interp2(pic(:,:,2),U,V),interp2(pic(:,:,3),U,V));
else
    %Same on all channels
    rec=cat(3,interp2(pic(:,:),U,V),interp2(pic(:,:),U,V),interp2(pic(:,:),U,V));
end
end