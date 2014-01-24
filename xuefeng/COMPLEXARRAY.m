classdef COMPLEXARRAY

    % COMPLEXARRAY
        % An array has size and data property
    
    properties (SetAccess = private)
        rows
        cols
    end
    
    properties
        data
    end
    
    methods 
        function this = COMPLEXARRAY(rows, cols)
            this.rows = rows;
            this.cols = cols;
            this.data = zeros(rows, cols);
        end
    end
end