f='W:\Fintan\Data\flame\videos\pool1.mp4';
o='W:\Fintan\Data\flame\videos\pool1FramesMasked\';
checkDir(o);
xyloObj = VideoReader(f);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames
    k
    mov(k).cdata = read(xyloObj, k);
    imwrite(mov(k).cdata,[o num2str(k) '.bmp'],'bmp');
end