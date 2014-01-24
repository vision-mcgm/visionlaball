function [ok,tFin] = task_naiveMeanFrame(c,nTargetModels,mS,f)
	%Warp images
	tStart=tic;
	
	Mx=0;
    My=0;
    MTex=0;
    for mT=1:nTargetModels %Loop over target models
        
        framePath=[rightPath(c,c.dirOutput) num2str(mS) 'to' num2str(mT) '\morph\frame' num2str(f) '.mat'];
        
        morph=load(framePath);
        
         Mx = Mx + morph.TPx;
        My = My + morph.TPy;
        MTex = MTex + morph.Texture;
    end
    
   
  
    %I have no idea why there is an extra 1 here. Taken from a legacy
    %function.
    Mx = (Mx / nTargetModels)+1;%+1; 
    My = (My / nTargetModels)+1;%+1;
    MTex = MTex / nTargetModels;
    
    vec=serialise(Mx,My,MTex);
    
    frame=morphvec2image(c,vec);
    
    outPath=[rightPath(c,c.dirOutput) 'mean\model' num2str(mS) 'frame' num2str(f) '.bmp'];
     imwrite(frame, outPath,'bmp');
   
    
    ok=1;
    tFin=toc(tStart);
end


