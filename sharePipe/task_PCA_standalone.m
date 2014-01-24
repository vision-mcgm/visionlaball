function [ok,tFin] = task_PCA(c)
	%Warp images
	tStart=tic;

	% Config settings.
% 	nFrames=209;
% 	PCs=50;
% 	p=3;
% 	h=120;
% 	w=100;
% 	ok=0;
    
    nFrames=c.frames;
	PCs=c.PCs;
	p=3;
	h=c.h;
	w=c.w;
	ok=0;
    
    allDir=[rightPath(c,c.dirPCAModel) 'all\'];

	MorphVectorFile=[allDir '\MorphVectors.mat'];
	PCAModelFile=[allDir '\PCAModel.mat'];
	MorphMeanFile=[allDir '\MorphMean.mat'];
	loadingsFile=[allDir '\loadings.mat'];
	varFile=[allDir '\variance.mat'];
	datFile='PCAModel.mat and MorphMean.mat and loadings.mat and variance.mat';

	load(MorphVectorFile,'Data');
	data=Data;
	[nDim nData] = size(data);
	meanVec = mean(data,2);
	data = data-repmat(meanVec,1,nData);
	XXT = data'*data;
	[dummy LSq V] = svd(XXT);
	LInv = 1./sqrt(diag(LSq));
	princComp  = data * V * diag(LInv);

	pcTrimmed=princComp(:, 1:PCs);

	MorphMean=meanVec;
 
	save(PCAModelFile,'pcTrimmed','MorphMean');
	save(MorphMeanFile,'MorphMean');

	loadings=(Data')*pcTrimmed;
	variance=var(loadings);
	save(loadingsFile,'loadings');
	save(varFile,'variance');
	ok=1;
	tFin=toc(tStart);
end
