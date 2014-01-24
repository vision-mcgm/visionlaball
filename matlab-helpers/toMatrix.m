function [ m ] = toMatrix( c )
%2D cell array of strings to 3D matrix padded by @ symbols

[h w]=size(c);

maxLen=1;
for ih=1:h
    for iw=1:w
        len=size(c{ih,iw},2);
       maxLen=max(maxLen,len);
    end
end

m=zeros(h,w,maxLen);

m(:)='@';

for ih=1:h
    for iw=1:w
        len=0;
        len=size(c{ih,iw},2);
        if len
        m(ih,iw,1:len)=c{ih,iw};
        end
    end
end
    




end

