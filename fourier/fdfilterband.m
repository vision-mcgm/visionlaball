function [ im ] = fdfilterband( im,bottom,top )
%Rem circle of radius r
if bottom==0 && top==0
    return
end
[si sj]=size(im);
%Image will always be odd
ci=floor(si/2)+1;
cj=floor(sj/2)+1;

for i=1:si
    for j=1:sj
        c=[ci cj];
        t=[i j];
        V = c - t;
d = sqrt(V * V');
if not(d > bottom && d < top)
    %We are not in the pass area - don't pass
    im(i,j)=0;
end
    end
end

end

