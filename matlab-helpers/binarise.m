function [ im2 ] = binarise( im )
%Binarise


im=rgb2gray(im);

m=mean(mean(im));

[h w]=size(im);

for i=1:h
    for j=1:w
        if im(i,j)<m
            im2(i,j)=0;
        else
            im2(i,j)=1;
        end
    end
end

end

