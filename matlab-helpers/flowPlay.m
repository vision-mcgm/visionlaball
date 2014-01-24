function [  ] = flowPlay( warpDir )
%Makes video of vector field



list=dir([warpDir '*.mat']);


l=size(list,1);



for i=1:l
    
    i
    myLoad=load([warpDir list(i).name]);
    
    im(:,:,:,i)=picflow_field(myLoad.TWx,myLoad.TWy);
    
   % Mov(i).cdata = im;
    %    Mov(i).colormap = [];
end

implay(im);
%movie2avi(Mov, [warpDir 'flowVid.avi'], 'fps', 25);
%system(['ffmpeg -i ' warpDir 'flowVid.avi '  warpDir 'flowVid.mpg']);
end

