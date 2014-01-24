function [ myPath ] = rightPath( config,rel )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isCluster
    myPath=[config.clusterRoot rel];
    msg='On cluster, ';
else
    myPath=[config.localRoot rel];
    msg='On local machine, ';
end

disp(['--------- ' msg 'accessing path ' myPath]);

end

