function [ ok,tFin ] = task_warp_group(c,frameFileSlice, refImage, dirFlowFields,nSlice)
	%Warp images
	tStart=tic;
	
    ovalWRadius=35;
    ovalHRadius=50;
    
	ok=0;
	nOps=size(nSlice,2);
    'worra'
    for op=1:nOps
        n=nSlice(op);
        frameFile=frameFileSlice(op).name;
        
        
        
	% Set parameters of McGM
    
     prec=ceil(log10(c.frames));
    format=['%.' num2str(prec) 'i'];
    
	mcgmcpp = 1.5;
	mcgmconv = 23;
	mcgmthresh = 0.1;
	nIts = 50;
	G=Gaussian(1.5,23);  		% adjust these values, then we may do conv2 once.
	
	% load and filter reference image
	ref=double(imread(refImage));
    ref=double(wipeOval(ref,50,60,ovalWRadius,ovalHRadius)); %Remove the oval
	ref2=conv2(conv2(rgb2gray(ref/255),G,'same'), G','same');  
	% glyn suggested to do it twice. Once might be OK.
	[h w]=size(ref2);
	[X Y]=meshgrid(1:w,1:h);
	% Store previous frame for continouse estimation 
	% Note in use in Harry's code. May need to change in the future!
	% Peng 23-03-2010
	prevWx=zeros(h, w);
	prevWy=zeros(h, w);
	rec=ref;
	target=double(imread(frameFile));
   target=double(wipeOval(target,50,60,ovalWRadius,ovalHRadius));
	target2=conv2(conv2(rgb2gray(target/255), G, 'same'), G', 'same');
    
    
	%     Warp at different scales for 120 x 100...
   if c.w==100
	    [Wx, Wy] = cswarp(ref2, target2, [0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
	    ... or for 240 x200
   elseif c.w==200
   altixLog('Im doing it 200.');
	         [Wx, Wy] = cswarp(ref2, target2, [0.05, 0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
   else
       %If it's another scale
       [Wx, Wy] = cswarp(ref2, target2, [0.1, 0.2, 0.4, 0.8], mcgmcpp, mcgmconv, mcgmthresh, nIts);
   end

	% warp from previous est...
	rec2=conv2(conv2(rgb2gray(rec/255), G, 'same'), G', 'same');
	[shot vel angles]=mcgm2(rec2, target2, mcgmcpp, mcgmconv, mcgmthresh); 
	[Ux Uy]=out2vecs(vel, angles);
	Ux(isnan(Ux))=0; 
	Uy(isnan(Uy))=0;
	% concatenate onto previous ff
	Vx=Ux+interp2(prevWx, X-Ux, Y-Uy); 
	Vx(isnan(Vx))=prevWx(isnan(Vx));
	Vy=Uy+interp2(prevWy, X-Ux, Y-Uy); 
	Vy(isnan(Vy))=prevWy(isnan(Vy));
	for j=1:nIts, %%no parfor
		[Vx, Vy]=refine(abs(ref2), Vx, Vy, 3);
	end
	% compare and merge
	err1 = sum((rgbinterp2(ref, X-Wx, Y-Wy)-target).^2, 3);
	err2 = sum((rgbinterp2(ref, X-Vx, Y-Vy)-target).^2, 3);
	err1 = conv2(err1, ones(3)/9, 'same');    
	err2 = conv2(err2, ones(3)/9, 'same');    
	w1 = repmat(1/2, h, w);
	w2 = repmat(1/2, h, w);
	den = err1+err2;
	w1(den~=0) = err2(den~=0)./den(den~=0);
	w2(den~=0) = err1(den~=0)./den(den~=0);
	prevWx = (w1.*Wx) + (w2.*Vx); prevWx(isnan(prevWx)) = 0;
	prevWy = (w1.*Wy) + (w2.*Vy); prevWy(isnan(prevWy)) = 0;
	TWx = wipeOval_matrix(prevWx,50,60,ovalWRadius,ovalHRadius);
	TWy = wipeOval_matrix(prevWy,50,60,ovalWRadius,ovalHRadius);
	save([dirFlowFields 'warp' num2str(n) '.mat'],'TWx','TWy');
    
    end
	ok=1;
	tFin=toc(tStart);
end

% ------------------------------------------------------------------

% cswarp function
function [Wx, Wy] = cswarp(ref, target, scales, mcgmcpp, mcgmconv, mcgmthresh, nIts)
	rec = ref;
	% figure; imshow(k*ref);
	[h w p] = size(ref);
	[X Y] = meshgrid(1:w, 1:h);
	Wx = zeros(h, w);
	Wy = zeros(h, w);
    %Iterate over different image scales, applying the mcgm to each one.
	for i = 1:size(scales, 2),
        neww = round(w*scales(i));
		newh = round(h*scales(i));
		srec = imresize(rec, [newh neww], 'bilinear');
		starget = imresize(target, [newh neww], 'bilinear');
		
		paddedrec = [zeros(mcgmconv, neww+(2*mcgmconv)); zeros(newh, mcgmconv) srec zeros(newh, mcgmconv); zeros(mcgmconv, neww+(2*mcgmconv))];
		paddedtarget = [zeros(mcgmconv, neww+(2*mcgmconv)); zeros(newh, mcgmconv) starget zeros(newh, mcgmconv); zeros(mcgmconv, neww+(2*mcgmconv))];
		[shot vel angles] = mcgm2(paddedrec, paddedtarget, mcgmcpp, mcgmconv, mcgmthresh);
		[Vx Vy] = out2vecs(vel, angles);
		mainVx = Vx(mcgmconv+1:mcgmconv+newh, mcgmconv+1:mcgmconv+neww);
		mainVy = Vy(mcgmconv+1:mcgmconv+newh, mcgmconv+1:mcgmconv+neww);
		W = abs(conv2(srec, [-1, -1, -1; -1, 8, -1; -1, -1, -1], 'same'));
		for j=1:nIts,
			[mainVx, mainVy] = refine(W, mainVx, mainVy, 3);
		end
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

function G=Gaussian(sigma,size)
	x=(-(size-1)/2) : ((size-1)/2);
	G=(1/sqrt(4*sigma*pi))*exp(-(x.^2)/(4*sigma));
end

function [Vx, Vy]=out2vecs(vel,angles)
	Vx=vel.*sin(angles*pi/180);
	Vy=vel.*cos(angles*pi/180);
end

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