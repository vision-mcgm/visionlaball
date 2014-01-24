function [ rem ] = rem2Loc( varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


if nargin==1
loc=varargin{1};
length=size('\\komodo\SharedData\Fintan\',2);

tail=loc(length+1:end);
rem=['W:\Fintan\' tail];
else
    config=varargin{1};
    loc=varargin{2};

length=size(config.clusterRoot,2);

tail=loc(length+1:end);
rem=[config.localRoot tail];

end

end

