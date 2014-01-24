function [ o ] = rmRoot(c, i )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
l=strfind(i,c.localRoot);
if size(l,1)==0
    
    l=strfind(i,c.clusterRoot);
    if size(l,1) ~= 0
        l=l(1);
    rmLen=size(c.clusterRoot,2)
    o=i(rmLen+1:end);
    else
        err = MException('ResultChk:OutOfRange', ...
        'Theres no root to remove.');
    

    throw(err)
    end
else
    l=l(1);
    rmLen=size(c.localRoot,2);
    o=i(rmLen+1:end);
end

end

