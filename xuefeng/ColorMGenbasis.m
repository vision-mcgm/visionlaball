function [basis] = ColorMGenbasis (Sfilters, t0, t1, t2)

% Genbasis create the filtered the frame sequence "basis"
    % basis has 3 (temproal derivatives) x 21 images
    % basis_i i[1 - 21] represents dx_n dy_m dt_0, where n, m <= 5
    % basis_i i[22 - 43] represents dx_n dy_m dt_1, where n, m <= 5
    % basis_i i[44 - 63] represents dx_n dy_m dt_2, where n, m <= 5

    NUM_TEMPORAL = 3;

    imrows = 1 + t0.rows - Sfilters.rows;
    imcols = 1 + t0.cols - Sfilters.rows;
    
%     tmp_row = IMAGE(imrows, imcols, 1);
    tmp_col = COLORIMAGE(t0.rows, imcols, Sfilters.cols);
    basis = COLORIMAGE(imrows, imcols, NUM_TEMPORAL*Sfilters.cols*(Sfilters.cols+1)/2);
%     tx = COLORIMAGE(0, 0, 0);
    index = 1;
    
    for t = 0:NUM_TEMPORAL-1
        switch t
            case 0
                tx = t0;
            case 1
                tx = t1;
            otherwise
                tx = t2;
        end
        
        for f = 1:Sfilters.cols
            tmp_col.data(:,:,1,f) = filter2(Sfilters.data(:,f)', tx.data(:,:,1,1), 'valid');
            tmp_col.data(:,:,2,f) = filter2(Sfilters.data(:,f)', tx.data(:,:,2,1), 'valid');
            tmp_col.data(:,:,3,f) = filter2(Sfilters.data(:,f)', tx.data(:,:,3,1), 'valid');
        end
        
        for n = 0:Sfilters.cols-1
            for f = 0:n
                for ff = 0:n
                    if (f + ff == n)
                        basis.data(:,:,1,index) = filter2(Sfilters.data(:,ff+1), tmp_col.data(:,:,1,f+1), 'valid');
                        basis.data(:,:,2,index) = filter2(Sfilters.data(:,ff+1), tmp_col.data(:,:,2,f+1), 'valid');
                        basis.data(:,:,3,index) = filter2(Sfilters.data(:,ff+1), tmp_col.data(:,:,3,f+1), 'valid');
                        index = index + 1;
                    end
                end
            end
        end
    end
end