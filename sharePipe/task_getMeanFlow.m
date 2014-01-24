function [ok,time] = task_getMeanFlow(MeanFFieldFile,c)
%Warp images


tStart = clock;
nFrames=c.frames;


for i = 1 : nFrames
     frameFileCell{i,1}=[rightPath(c,c.dirPCAModel) 'warp\warp' num2str(i,'%03d') '.mat'];
    
end

[ Mx,My,rMx,rMy ] = getMeanFlow_util(frameFileCell);

save(MeanFFieldFile,'Mx','My','rMx','rMy');

ok=1;
time=etime(clock,tStart);

end

