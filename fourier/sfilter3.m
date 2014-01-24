function [ out ] = sfilter3( im,lo,hi )
%Spat filter a colour image, expressed as a double (always use doubles from
%here on it)

[i j col]=size(im);
out=zeros(i,j);

for c=1:3
    slice=squeeze(im(:,:,c));
    rec=sfilter(slice,lo,hi);
    out(:,:,c)=rec;
end


end

