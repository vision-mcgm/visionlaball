function [collect] = ColorMFtfilter(frame, imdirname, filter)
%MFtfilter Summary of this function goes here
%   Detailed explanation goes here
    
    mrows = size(filter, 1);

    imname = [imdirname, num2str(frame,'Mary%.3d'), '.bmp'];
    bim = imread(imname);
    im = double(bim);
%     im  = double(imresize(bim, 1/3, 'bilinear'));
    [rows, cols, dim] = size(im);
    if dim == 1
        disp('Input must be a color image!');
        return;
    end
    
    collect = COLORIMAGE(rows, cols, 1);
    %% RGB image
%     im = im;
    %% HSV image
%     im = rgb2hsv(im);
    %% Spectrum derivative Image
    im = ColorDeri(im);
    
    collect.data(:,:,1,1) = im(:,:,1)*filter(1);
    collect.data(:,:,2,1) = im(:,:,2)*filter(1);
    collect.data(:,:,3,1) = im(:,:,3)*filter(1);
    
    for f = 1:mrows-1
        imname = [imdirname, num2str(frame+f,'Mary%.3d'), '.bmp'];
        bim = imread(imname);
        im = double(bim);
%         im = double(imresize(bim, 1/3, 'bilinear'));
        
%         im = rgb2hsv(im); % HSV image
        im = ColorDeri(im); % Spectrum derivative Image
        for i=1:3
            collect.data(:,:,i,1) = collect.data(:,:,i,1) + im(:,:,i)*filter(f+1);
        end
    end
end

