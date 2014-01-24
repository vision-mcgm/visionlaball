%Given a polar-coords 2D image (2nd channel of HSV), start at the left and
%cut off everything below a certain level.

%Working on doubles!

im=ch2;

[h w]=size(ch2);

thresh=0.1;

mask=zeros(h,w);

for ih=1:h
    for iw=1:w
        %Going along one radial line from outside to inside
        iwC=(w-iw+1); %Complement so that we start from the right
        v=im(ih,iwC);
        
        if v > thresh
            mask(ih,iwC)=1;
            im(ih,iwC)=1;
            radLimits(ih)=iwC;
            break
        end
        
        
    end
end

imshow(im);