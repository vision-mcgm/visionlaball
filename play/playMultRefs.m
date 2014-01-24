%Runs several PCAs with different references

%Params

config='X:\VisionLabLibrary\Configs\gaze_r_c.pca';

c=readConfig(config);
n=c.frames;

l=dir([rightPath(c,c.dirSourceBitmaps) '*.bmp']);

for i=1:n
    thisC=c;
    thisC.referenceFrameFiles={l(i).name};
    thisC.dirPCAModel=[thisC.dirPCAModel(1:end-1) '_ref' num2str(i) '\'];
    configs{i}=thisC;
    buildPCA(thisC);
end

playMultRefs2

thisC=c;
dFinalSourceRel=  [c.dirSourceBitmaps 'means\'];
thisC.dirSourceBitmaps= dFinalSourceRel
thisC.dirPCAModel=[c.dirSourceBitmaps 'means\pca\'];
l=dir([rightPath(thisC,thisC.dirSourceBitmaps) '*.bmp']);
r=input('Choose ref image?','s');
thisC.referenceFrameFiles={r};
buildPCA(thisC);