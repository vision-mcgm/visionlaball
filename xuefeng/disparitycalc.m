Mvideo_vel_ang

% disparityangle=nanmean(mod(speed1(:),180));
disparityangle=0;
[B1 B2]=pol2cart(speed1*pi/180,speed0);
disparity=(B1.^2+B2.^2)./(B1*cos(disparityangle*pi/180)+B2*sin(disparityangle*pi/180));
finitedisparity=disparity;
finitedisparity(isnan(finitedisparity))=0;
displow=mean(finitedisparity(:))-mad(finitedisparity(:));
disphigh=mean(finitedisparity(:))+mad(finitedisparity(:));

normalizeddisparity=(finitedisparity-displow)/(disphigh-displow);