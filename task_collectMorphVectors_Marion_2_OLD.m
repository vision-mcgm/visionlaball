function [ok,tFin] = task_collectMorphVectors_Marion_2(c,morphDir,allDir,speechvector)
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
    
    s=size(speechvector(:,1))

	Data = zeros(h*w*5+s(1,1)*2, nFrames);
	for i=1:nFrames
		morphFile=[morphDir 'morph' num2str(i,format) '.mat'];
		load(morphFile);
        Data(:, i) = [TPx(:)', TPy(:)', Texture(:)' ];
        error('This is the right file');
        for k=1:4096
            if k==1
                
                altixDump(speechvector);
            end
		Data(:, i) = [Data(:, i),  real(speechvector(k,i))', imag(speechvector(k,i))' ]';	
        end 
        
        Data=Data';
	end
    MorphMean = mean(Data,2);
   
    save([allDir '\MorphMean.mat'],'MorphMean');
    save([allDir '\MorphVectors.mat'],'Data');
    ok=1;
    tFin=toc(tStart);					% Record the task duration.
end
