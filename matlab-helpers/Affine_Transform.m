% Subroutine for affine tranformation to a morph vector
%
% Peng Revised from original code 24-05-2010
function Y = Affine_Transform(Qx, Qy, Texture, T, w, h)
Qx = imtransform(Qx, T, 'xdata', [1 w], 'ydata', [1 h]);
Qy = imtransform(Qy, T, 'xdata', [1 w], 'ydata', [1 h]);
Texture = imtransform(Texture, T, 'xdata', [1 w], 'ydata', [1 h]);
Y = [Qx(:)', Qy(:)', Texture(:)']';
end