function [  ] = probeFace( img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pos = fdlibmex(img,-4);

% display the image
imagesc(img)
colormap gray
axis image
axis off

% draw red boxes around the detected faces
hold on
for i=1:size(pos,1)
    r = [pos(i,1)-pos(i,3)/2,pos(i,2)-pos(i,3)/2,pos(i,3),pos(i,3)*1.3];
    rectangle('Position', r, 'EdgeColor', [1,0,0], 'linewidth', 2);
end
hold off

% show stats
fprintf('\n--- fdlibmex example ---\n');
fprintf('\n\t%d faces detected in \''%s\'' (see figure 1)\n\n', ...
    size(pos,1), imgfilename);
end

