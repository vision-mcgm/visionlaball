function [ c ] = pcFolder( f,ref )
%Runs a PCA on the local path given in the argument

c=config('UNIVERSAL.pca');

f=checkSlash(f);

list=dir([checkSlash(f) '*.bmp']);
frames=size(list,1);

im=imread([f list(1).name]);
[h w d]=size(im);

root=c.localRoot;
l=size(root,2);
f2=f(l+1:end);
f2=checkSlash(f2);

c.dirSourceBitmaps=f2;

c.dirPCAModel=[f2 'pca\'];
c.referenceFrameFiles={ref};
c.PCs=min(frames,50);

c.h=h;
c.w=w;

buildPCA(c);

end

