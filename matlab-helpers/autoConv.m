function [ rel ] = autoConv( config,rel )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isCluster
    if size(rel,2) >= size(config.localRoot,2)
        if strcmp(rel(1:size(config.localRoot,2)),config.localRoot)
            rel=loc2Rem(config,rel);
        end
    end
else
    if size(rel,2) >= size(config.clusterRoot,2)
        if strcmp(rel(1:size(config.clusterRoot,2)),config.clusterRoot)
            rel=rem2Loc(config,rel);
        end
    end
end

