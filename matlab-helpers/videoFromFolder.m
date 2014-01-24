function [  ] = videoFromFolder( varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

nmax=100;
color=0;
if nargin == 0
    [FileName,PathName,FilterIndex]=uigetfile
else
    PathName=varargin{1};
end

if not(strcmp(PathName(end),'\'))
    PathName(end+1)='\';
end

sourceFiles=dir([PathName '*.bmp']);

frame1=imread([PathName sourceFiles(1).name]);

[h w d]=size(frame1);

frames=size(sourceFiles,1);

if color
for i=1:min(nmax,frames)
    combiFrame = zeros(h,w,3);
    sourceFrame=imread([PathName sourceFiles(i).name]);
    combiFrame(:,:,:) = double(sourceFrame)/255;
    Combi(i).cdata = combiFrame;
        Combi(i).colormap = [];
end
else
    for i=1:min(nmax,frames)
    combiFrame = zeros(h,w);
    sourceFrame=imread([PathName sourceFiles(i).name]);
    combiFrame(:,:) = double(sourceFrame)/255;
    Combi(i).cdata = combiFrame;
        Combi(i).colormap = [];
    end
end

fprintf('Building AVI...\n');

%This function builds the AVI file from the movie object Combi and outputs
%it
movie2avi(Combi, [PathName 'Compare.avi'], 'fps', 25, 'compression', 'none');
end

