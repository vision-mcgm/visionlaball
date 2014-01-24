function [ out ] = imScale( in )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
[h w c]=size(in);

if c==1
maxi=max(max(in));
mini=min(min(in));

diff = 0-mini;

in=in+diff;

in=in/(maxi-mini);

out=in;
elseif c==3
    for i=1:3
        maxi=max(max(in(:,:,i)));
mini=min(min(in(:,:,i)));

diff = 0-mini;

in(:,:,i)=in(:,:,i)+diff;

in(:,:,i)=in(:,:,i)/(maxi-mini);

    end
end

out=in;
end

