classdef COLORIMAGE

    % COLORIMAGE
        % An array has size of image, number of images, and data property
    
    properties (SetAccess = private)
        rows
        cols
    end
    properties
        numimages
        data
    end
    
    methods
        function this = COLORIMAGE(rows, cols, numimages)
            this.rows = rows;
            this.cols = cols;
            this.numimages = numimages;
            this.data = zeros(rows, cols, 3, numimages);
        end
    end
end