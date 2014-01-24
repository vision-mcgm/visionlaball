% deserialise(vec,c) or
% deserialise(vec,w,h)
function [Qx, Qy, Texture] = deserialise(vec,varargin)

if nargin==2
    h=c.h;
    w=c.w;
else
    h=varargin{2};
    w=varargin{1};
end

veclength=h*w;
%Split the vector into 3 parts, X y and texture, and reshape them into
%matrices
Qx=reshape(vec(1:veclength),h,w);
Qy=reshape(vec(veclength+1:2*veclength),h,w);
Texture=reshape(vec((2*veclength)+1:veclength*5),h,w,3);


end