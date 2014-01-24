function [ok,tFin] = task_PCA_Marion(c,c1)
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
    allDir=[rightPath(c,c.dirPCAModel) 'all'];

	MorphVectorFile=[allDir '\MorphVectors.mat'];
	PCAModelFile=[allDir '\PCAModel.mat'];
	MorphMeanFile=[allDir '\MorphMean.mat'];
	loadingsFile=[allDir '\loadings.mat'];
	varFile=[allDir '\variance.mat'];
    morphMeanImageFile=[allDir '\morphMean.bmp'];
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
    


    calculatedPCs=size(princComp,2);
	pcTrimmed=princComp(:, 1:min(PCs,calculatedPCs));

	MorphMean=meanVec;
    morphMeanImage=morphvec2image(MorphMean(1:h*w*5),w,h);
 
    PCA=pcTrimmed;
	save(PCAModelFile,'PCA','MorphMean');
	save(MorphMeanFile,'MorphMean');
    imwrite(morphMeanImage,morphMeanImageFile, 'bmp');

    MMMatrix=repmat(MorphMean,1,nData);
    Data=Data-MMMatrix;
	loadings=(Data')*pcTrimmed; %Bug fixed: take away morph mean first.
	variance=var(loadings);
	save(loadingsFile,'loadings');
	save(varFile,'variance');
    
    
    
    
    
     nFrames=c1.frames;
	PCs=c1.PCs;
	p=3;
	h=c1.h;
	w=c1.w;
	ok=0;
    allDir=[rightPath(c1,c1.dirPCAModel) 'all'];

	MorphVectorFile=[allDir '\MorphVectors.mat'];
	PCAModelFile=[allDir '\PCAModel.mat'];
	MorphMeanFile=[allDir '\MorphMean.mat'];
	loadingsFile=[allDir '\loadings.mat'];
	varFile=[allDir '\variance.mat'];
    morphMeanImageFile=[allDir '\morphMean.bmp'];
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
    


    calculatedPCs=size(princComp,2);
	pcTrimmed=princComp(:, 1:min(PCs,calculatedPCs));

	MorphMean=meanVec;
    morphMeanImage=morphvec2image(MorphMean(1:h*w*5),w,h);
 
    PCA=pcTrimmed;
	save(PCAModelFile,'PCA','MorphMean');
	save(MorphMeanFile,'MorphMean');
    imwrite(morphMeanImage,morphMeanImageFile, 'bmp');

    MMMatrix=repmat(MorphMean,1,nData);
    Data=Data-MMMatrix;
	loadings=(Data')*pcTrimmed; %Bug fixed: take away morph mean first.
	variance=var(loadings);
	save(loadingsFile,'loadings');
	save(varFile,'variance');
	ok=1;
	tFin=toc(tStart);
end
