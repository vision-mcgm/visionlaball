function [final] = ColorDeri( RGB )
% ColorDeri converts RGB image into 0, 1, 2 spectrum derivative
%   COded by Xuefeng Liang

%     rgb2xyz = [.621 .113 .194; .297 .563 .049; -.009 .027 1.105];
% %     xyz2e = [-.019 .048 .011; .019 0 -.016; .047 -.052 0]; %powerpoint version
%     xyz2e = [-.48 1.2 .28; .48 0 -.4; 1.18 -1.3 0]; % PAMI version
%     colorRF = xyz2e * rgb2xyz;

    final = zeros(size(RGB));
%%  Gaussan color model transform by Liang    
    colorRF = [.0558 .6289 .2751; .3017 .0434 -0.3489; .3467 -0.5986 .1652];

    cacim = permute(RGB, [3 1 2]);

    [x y z] = size(cacim);
    resim = zeros(x,y,z); clear x y;

    for i = 1:z
        resim(:,:,i) = colorRF * cacim(:,:,i);
    end

    final = permute(resim, [2 3 1]);
%%  Geusebroek online version
%     R = double(RGB(:,:,1));
%     G = double(RGB(:,:,2));
%     B = double(RGB(:,:,3));
% % JMG: slightly different values than in PAMI 2001 paper;
% %      simply assuming correctly white balanced camera
%     E   = (0.3*R + 0.58*G + 0.11*B ) / 255.0;
%     El  = (0.25*R  + 0.25*G - 0.5*B ) / 255.0;
%     Ell = (0.5*R - 0.5*G) / 255.0;
%     final(:,:,1) = E;
%     final(:,:,2) = El;
%     final(:,:,3) = Ell;
end

