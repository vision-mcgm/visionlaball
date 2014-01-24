% Reconstruct the image from morph vector, which is given as separate
%components: new pixel positions (NOT WARP FIELDS) for X and Y, and the
%texture. 
% %This is called either m(c,X) or m(x,W,H)
% Peng Li revised 24-05-2010
function Y = morphvec2image_components(tex,Px,Py,h,w)
%This is called either m(c,X) or m(x,W,H)

% Split face vector into pixel position and texture components
% Px = reshape(X(1:w*h), h, w);
% Py = reshape(X(1+w*h : 2*w*h), h, w);

% Wx=Px;
% Wy=Py;

%We don't need to convert from warp fields to new pixel positions, because
%this has already been done - this function accepts new pixel positions.

%   Wx=conv2(conv2(Wx,Gaussian(1.5,23),'same'),Gaussian(1.5,23)','same');
%     Wy=conv2(conv2(Wy,Gaussian(1.5,23),'same'),Gaussian(1.5,23)','same');
% 
% % Amended lines added by HG 16/07/10, see original function morphvec2data.m
% 
% % For 240 x 200 pixel images
% %     Wx = conv2(conv2(Wx, Gaussian(3, 46), 'same'), Gaussian(3, 46)', 'same');
% %     Wy = conv2(conv2(Wy, Gaussian(3, 46), 'same'), Gaussian(3, 46)', 'same');
%     
%     % adjust flow field to point to mean    
%     Vx = Wx + interp2(rMx, X-Wx, Y-Wy); Vx(isnan(Vx))=0;
%     Vy = Wy + interp2(rMy, X-Wx, Y-Wy); Vy(isnan(Vy))=0;
%      
%     [rVx, rVy] = invertflowfield(Vx, Vy);
%     Px = X-rVx; Px(Px<1) = 1; Px(Px>w) = w;
%     Py = Y-rVy; Py(Py<1) = 1; Py(Py>h) = h;
%     rec = rgbinterp2(im, Px, Py); rec(isnan(rec)) = 0;
%     rec = rec.*cat(3, mask, mask, mask);
%     Px = X-Vx-1; Px(Px<0) = 0; Px(Px>w-1) = w-1; Px(isnan(Px)) = X(isnan(Px));
%     Py = Y-Vy-1; Py(Py<0) = 0; Py(Py>h-1) = h-1; Py(isnan(Py)) = Y(isnan(Py));


% Correct impossible pixel position values
Px(Px<1) = 1; 
Px(Px>w) = w;
Py(Py<1) = 1; 
Py(Py>h) = h;
            
% Replace negative RGB values with zero
tex(tex<0) = 0;
tex(tex>255) = 255;
           
% Interpolate faces from texture and shape
Y = rgbinterp2(tex, Px, Py);
            
% Replace negative RGB values with zero
Y(Y < 0) = 0;
Y(Y > 255) = 255;

Y = Y ./ 255;   % Rescale to 0-1 to store
end

% Rgb version of interp2- written when glyn got sick of typing this for the millionth time
function rec = rgbinterp2(pic, U, V)
rec = cat(3, interp2(pic(:,:,1), U, V), interp2(pic(:,:,2), U, V), interp2(pic(:,:,3), U, V));
end

% function G=Gaussian(sigma,size)
function G=Gaussian(sigma,size)
x = (-(size-1)/2) : ((size-1)/2);
G = (1/sqrt(4*sigma*pi))*exp(-(x.^2)/(4*sigma));
end