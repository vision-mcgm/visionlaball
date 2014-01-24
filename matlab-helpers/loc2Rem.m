function [ rem ] = loc2rem( varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    loc=varargin{1};
    length=size('W:\Fintan\',2);

tail=loc(length+1:end);
rem=['\\komodo\SharedData\Fintan\' tail];
else
    config=varargin{1};
    loc=varargin{2};
length=size(config.localRoot,2);

tail=loc(length+1:end);
rem=[config.clusterRoot tail];
end

end

