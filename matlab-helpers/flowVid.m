function [  ] = flowVid( c )
%Makes video of vector field

warpDir = [rightPath(c,c.dirPCAModel) 'warp\'];

flowVid_util(warpDir);
end

