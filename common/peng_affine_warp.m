% Affine transformation for an image given the control points in both
% source and target images.
%
%   Input:
%       ImgIn       -   Source image (RGB - h x w x 3 uint8 matrix)  
%       SourcePoints-   Control point of source image (K x 2 matrix)
%       TargetPoints-   Control point of target image (K x 2 matrix)
%   Output:
%       ImgOut      -   Transformed image (RGB - h x w x 3 uint8 matrix)
%
% Peng Li 27-05-2010
function ImgOut = peng_affine_warp(ImgIn, SourcePoints, TargetPoints)
% Fill value to expand the image
FillValue = mean2(ImgIn([1, end],:,:)); 
% Size of the border to add to the image
BORDER_SIZE = round(min([size(ImgIn, 1), size(ImgIn, 2)]) / 2) ;

% Eembed original image in border
ImBorder = uint8(FillValue*ones(size(ImgIn, 1) + 2*BORDER_SIZE, ...
    size(ImgIn, 2) + 2 * BORDER_SIZE, 3));

ImBorder(BORDER_SIZE + 1 : BORDER_SIZE + size(ImgIn, 1), ...
    BORDER_SIZE + 1 : BORDER_SIZE + size(ImgIn, 2), :) = ImgIn;

% Add border offset to control points
FromPoints = SourcePoints + BORDER_SIZE;
ToPoints = TargetPoints + BORDER_SIZE;

% Calculate the transformation matrix
TRANSMX = cp2tform(FromPoints, ToPoints, 'affine');

ImgTransformed = imtransform(ImBorder, TRANSMX, 'XData', ...
    [1 size(ImBorder, 2)],'YData', [1 size(ImBorder, 1)],...
    'fillValues', FillValue);

ImgOut = ImgTransformed(BORDER_SIZE+1:BORDER_SIZE+size(ImgIn,1), ...
    BORDER_SIZE + 1 : BORDER_SIZE + size(ImgIn, 2),:);
end
