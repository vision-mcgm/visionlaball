function [ wx wy ] = mcgm_util( source,target )
%Returns mcgm in standard warp offset format

[shot vel angles]=mcgmHelper(source, target);
[wx wy]=out2vecs(vel,angles);

end