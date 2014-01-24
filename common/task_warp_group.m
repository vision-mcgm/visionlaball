function [ ok,tFin ] = task_warp_group(c,frameFileSlice, refImage, dirFlowFields,nSlice,node)
	%Warp images

    nodeLog(node,sprintf('Lab %d starting warps.',node));
    
	tStart=tic;
	
	ok=0;
	nOps=size(nSlice,2);
    'worra'
    for op=1:nOps
        n=nSlice(op);
        frameFile=frameFileSlice(op).name;     
        target=imread(frameFile);
        ref=imread(refImage);
        try
        [TWx TWy]=warp_util(target,ref);
        catch
             nodeLog(node,['ERROR in warp ' num2str(n,'%03d') ]);
        end
	% Set parameters of McGM
    
     prec=ceil(log10(c.frames));
    format=['%.' num2str(prec) 'i'];
    

    nodeLog(node,['Saving warp file ' num2str(n) ]);
	save([dirFlowFields 'warp' num2str(n,'%03d') '.mat'],'TWx','TWy');
    nodeLog(node,['SAVED warp file ' num2str(n,'%03d') ]);
    
    end
	ok=1;
	tFin=toc(tStart);
    nodeLog(node,sprintf('Lab %d finished warps.',node));
end
