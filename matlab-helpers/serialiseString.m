function [ o ] = serialiseString( s )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[r c]=size(s);

o='';
for i=1:r
    o=[o s(i,:)];
end

end

