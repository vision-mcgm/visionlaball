function [ Mx,My,rMx,rMy ] = getMeanFlow_util_data( TVx,TVy )
%Coords of input matrices are T,R,C (T,Y,X)
nFrames=size(TVx,1);


[t h w]=size(TVx);

% Initialize the mean flow field and its reverse
Mx = zeros(h, w);
My = Mx;
rMx = Mx;
rMy = Mx;

% calculate mean flow field...
Mx = zeros(h, w);
My = Mx;
for i = 1 : nFrames
     TWx=squeeze(TVx(i,:,:));
     TWy=squeeze(TVy(i,:,:));
    Mx = Mx + TWx;
    My = My + TWy;
end
Mx = Mx / nFrames;
My = My / nFrames;

% Calculate the inverse mean flow field
[rMx, rMy] = invertflowfield(Mx, My);

end

% Calculate inverse flow field given a flow field
% The original code somtimes reports a qhull precision error when using
% griddata function. Here the data are rescled before the preprocessing.
% May need to adapt to the data in the future!!!
%
% Peng Li 25-03-2010
function [rVx, rVy] = invertflowfield(Vx, Vy)
[h w] = size(Vx);
[X Y] = meshgrid(1:w, 1:h);

S = 1e2; % Scale factor - may need to adapt to different data (Peng)

rVx = griddata((X-Vx) ./ S, (Y-Vy) ./ S, -Vx ./ S, X ./ S, Y ./ S); 
rVx = rVx .* S;
rVx(isnan(rVx)) = 0;

rVy = griddata((X-Vx) ./ S, (Y-Vy) ./ S, -Vy ./ S, X ./ S, Y ./ S);  
rVy = rVy .* S;
rVy(isnan(rVy)) = 0;
end

