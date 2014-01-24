function [ success ] = task_spfilter(filenames )
%filenames are loc
%outnames are rem

success=0;

out='\\komodo\SharedData\Fintan\ftest\';

n=size(filenames,1);

for i=1:n
    fname=loc2Rem(filenames(i).name);
    im=imread(fname);
    lo=200;
    hi=300;
    [pathstr name ext]=fileparts(fname);
    
    outname=[out name ext];
    
    rec=sfilter3(im,lo,hi);
    imwrite(rec,outname,'bmp');
    
    
    
    
end

