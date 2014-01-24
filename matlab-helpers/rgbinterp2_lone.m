function [rec] = rgbinterp2_lone(pic, U, V)
rec = cat(3, interp2(pic(:,:,1), U, V), interp2(pic(:,:,2), U, V), interp2(pic(:,:,3), U, V));
end