function [ rec ] = sfilter( im,lo,hi )
%Spat filter image, assume double (use doubles everywhere)

ft=fft2(im);
fta=fftshift(ft);
ftfa=fdfilterband(fta,lo,hi);
ftf=ifftshift(ftfa);
rec=ifft2(ftf);

figure(5)
%ftplot(fta);
%tst=log(abs(ftfa));
%tst=imresize(tst,0.5);
%contour(tst)

end

