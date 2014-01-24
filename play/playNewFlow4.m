%Allows you to place some keypoints in the reference image, then shows you
%how they move around in the other images according to the warps.

%ASSUMES warps are from the reference.



name='atkinson';
f.l=['W:\Fintan\Data\motion\processed\' name '\'];
f.r=['\\komodo\SharedData\Fintan\Data\motion\processed\' name '\'];

refF=importdata([f.l 'ref.txt']);
refF=refF{1}; %To remove from cell

refImage= [f.l refF];
iR=imread(refImage);
imshow(iR);

[refX refY] = ginput;
points=size(refX,1);
list=dir([f.l '*.bmp']);

l=size(list,1);

warpDir =[f.l 'warp\'];

for i=1:l
    thisIm=imread([f.l list(i).name]);
    
    thisWarp=load([warpDir 'warp' num2str(i,'%03d') '.mat']);
    
    
    for p=1:points
       % thisdX=thisWarp.TWx(round(refY(p)),round(refX(p)));
      %  thisdY=thisWarp.TWy(round(refY(p)),round(refX(p)));
      
      [thisdX thisdY]=avgFlow(thisWarp.TWx,thisWarp.TWy,round(refX(p)),round(refY(p)));
        
        thisX=thisdX+refX(p);
        thisY=thisdY+refY(p);
        
        thisX=round(thisX);
        thisY=round(thisY);
        
     %thisX=round(refX(p));
      %  thisY=round(refY(p));
        
        thisIm=imCross(thisIm,thisX,thisY);
    end
    
    imshow(thisIm);
    
    pause(0.04);
end
    
    

