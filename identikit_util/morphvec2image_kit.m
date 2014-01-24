% Reconstruct the image from morph vector
% 
% Peng Li revised 24-05-2010
function Y = morphvec2image(X, varargin)

optargin=size(varargin,2);

if optargin == 1
    c=varargin{1};
    w=c.w;
    h=c.h;
elseif optargin ==2
        w=varargin{1};
        h=varargin{2};
    end

% Split face vector into pixel position and texture components
 Px = reshape(X(1:w*h), h, w);
 Py = reshape(X(1+w*h : 2*w*h), h, w);

% Amended lines added by HG 16/07/10, see original function morphvec2data.m
% Px = reshape(X(1:w*h), h, w)+1;
% Py = reshape(X(1+w*h : 2*w*h), h, w)+1;

tex = reshape(X(1+2*w*h : end), [h, w, 3]);

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