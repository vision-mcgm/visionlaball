%Loads warps into a variable warps so they can be accessed later

%warpDir = [rightPath(c,c.dirPCAModel) 'warp\'];

%root='W:\Fintan\Data\motion\atkinson\pca\';

%warpDir = [root 'warp\'];

%Set this to run from a file path
warpDir='W:\Fintan\Data\motion\processed\atkinson\warp\';

listDir=[warpDir '*.mat'];

list=dir(listDir);

l=size(list,1);



clear warps

for i=1:l
    
    i
    warps(i)=load([warpDir list(i).name]);
    
    
    
   % im=picflow_field(myLoad.TWx,myLoad.TWy);
    
  %  Mov(i).cdata = im;
       % Mov(i).colormap = [];
end



