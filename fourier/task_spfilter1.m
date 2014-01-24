function [ success ] = task_spfilter(filenames )
%filenames are loc
%outnames are rem

success=0;

out='\\komodo\SharedData\Fintan\ftest\';

n=size(filenames,1);

for i=1:n
    fname=loc2Rem(filenames(i).name);
    im=imread(fname);
    lo=0;
    hi=300;
    [pathstr name ext]=fileparts(fname);
    
    outname=[out name ext];
    im=rgb2gray(im);
    rec=sfilter(im,lo,hi);
    imwrite(rec,outname,'bmp');
    
    
    
    
end

