function [ok,tFin] = task_collectMorphVectors(c,morphDir,allDir)
	%Warp images
	tStart=tic;
    
    nodeLog(1,'starting collectMorphVectors');
    nodeLog(1,num2str(labindex));
    nodeLog(1,'tried to save labindex');
    

	% Config settings.
	nFrames=c.frames;
	PCs=c.PCs;
	p=3;
	h=c.h;
	w=c.w;
	ok=0;

    
    prec=ceil(log10(nFrames));
    format=['%.' num2str(prec) 'i'];
    
	Data = zeros(h*w*5, nFrames);
	for i=1:nFrames
		morphFile=[morphDir 'morph' num2str(i,'%03d') '.mat'];
		load(morphFile);
		Data(:, i) = [TPx(:)', TPy(:)', Texture(:)']';	
	end
    MorphMean = mean(Data,2);

%Iterative averaging
% 
%     for i=1:nFrames
% 		morphFile=[morphDir 'morph' num2str(i,'%03d') '.mat'];
% 		load(morphFile);
% 		thisOne = [TPx(:)', TPy(:)', Texture(:)']';	
%         MorphMean=MorphMean+thisOne;
%     end
%     MorphMean=MorphMean/nFrames;
   
    nodeLog(1,'Saving files...');
    save([allDir '\MorphMeanTEST.mat'],'Texture');
    save([allDir '\MorphMean.mat'],'MorphMean');
    save([allDir '\MorphVectors.mat'],'Data'); %To save large variable (perhaps with compression)
    nodeLog(1,'files saved.');
    ok=1;
    tFin=toc(tStart);					% Record the task duration.
end
