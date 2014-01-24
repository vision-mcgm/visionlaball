function [ok,tFin] = task_collectMorphVectors_m(c,morphDir,allDir,c1,morphDir1,allDir1)
	%Warp images
	tStart=tic;

	% Config settings.
	nFrames=c.frames;
	PCs=c.PCs;
	p=3;
	h=c.h;
	w=c.w;
	ok=0;

    
    prec=ceil(log10(nFrames));
    format=['%.' num2str(prec) 'i'];
    
	Data = zeros(h*w*5*2, nFrames);
	for i=1:nFrames
		morphFile=[morphDir 'morph' num2str(i,format) '.mat'];
		load(morphFile);
         Data(1:h*w*5, i) = [TPx(:)', TPy(:)', Texture(:)']';	

       	morphFile=[morphDir1 'morph' num2str(i,format) '.mat'];
    		load(morphFile);
            a=Data(1:h*w*5,i);
         Data(:, i) = [a(:)' , TPx(:)', TPy(:)', Texture(:)']';	

    end
    
 
    MorphMean0 = mean(Data(1:188000,:),2);
    save([allDir '\MorphMean0.mat'],'MorphMean0');
    MorphMean1 = mean(Data(1+188000:end,:),2);
    save([allDir '\MorphMean1.mat'],'MorphMean1');
    save([allDir '\MorphVectors.mat'],'Data');
    ok=1;
    tFin=toc(tStart);					% Record the task duration.
end
