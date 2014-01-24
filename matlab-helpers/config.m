function [ c ] = config( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cDir='\\komodo.psychol.ucl.ac.uk\JobData1\VisionLabLibrary\Configs\';
if nargin==1
    
a=varargin{1};
c=readConfig([cDir a]);
else
    dir(cDir)
end
end

