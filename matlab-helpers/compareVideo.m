function [  ] = comparevideo( c )

%Thhis function takes a TRANSFER config file (which links to two PCA files
%for source and target PCA spaces).

%Read in the two PCA files
c1=config(c.sourceConf);
c2=config(c.targetConf);

%addpath(rightPath(c,c.dirCode));

%Error checking
if size(c1.models,2)>1
    error('There are multiple models in the source directory.');
end
if c1.w ~= c2.w || c1.h ~= c2.h
    error('Source and targets are different sizes!');
end

h=c1.h;
w=c1.w;

%Get source and target directories
sourceFiles=dir([rightPath(c1,c1.dirSourceBitmaps) '*.bmp']);
targetFiles=dir([rightPath(c,c.dirOutput) '*.bmp']);

MovIndex = 0;

%Loop over frames
disp('Collecting frames...');
for i=1:c.frames
 
    disp(i)
    
    %fprintf('Frame %d...\n',i);
    MovIndex = MovIndex + 1;
   
%Read in the images for source and target using imread
    sourceFrame=imread(rightPath(c1,[c1.dirSourceBitmaps sourceFiles(i).name]));
    targetFrame=imread(rightPath(c,[c.dirOutput targetFiles(i).name]));
    
    %Build an image matrix into which to put the frames
    combiFrame = zeros(h,3*w+20,3);
%Put source frame in
    combiFrame(:,1:w,:) = double(sourceFrame)/255;
    %Put target frame in
    combiFrame(:,w+11:2*w+10,:) = double(targetFrame)/255;
    
    %NOTE: the sourceFrame and targetFrame have datatype UINT32 which can
    %only hold 256 values, integers between 0 and 255. combiFrame has
    %datatype DOUBLE which can hold many millions of values; in this case
    %we want them to be between 0 and 1 (this is one of Matlab's image
    %representations) so we convert UINT32 to double using the double()
    %function and then divide by 255 to rescale to the interval [0,1]
    
    %Give the movie object (Combi) colour data combiFrame for frame
    %MovIndex
    Combi(MovIndex).cdata = combiFrame;
        Combi(MovIndex).colormap = [];
        
        
    
    
end


fprintf('Building AVI...\n');

%This function builds the AVI file from the movie object Combi and outputs
%it
movie2avi(Combi, [rightPath(c,c.dirOutput) 'Compare.avi'], 'fps', 25, 'compression', 'none');

end

