% Subroutine for affine tranformation to a morph vector
%
% Peng Revised from original code 24-05-2010
function Y = serialise(Qx, Qy, Texture)

Y = [Qx(:)', Qy(:)', Texture(:)']';
end