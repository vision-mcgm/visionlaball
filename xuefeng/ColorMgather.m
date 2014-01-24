function [M0, M1, M2, M3] = ColorMgather(basis, angle, orders, weights, filterthreshold, divisionthreshold)
%MGATHER Summary of this function goes here
%   Detailed explanation goes here

    num_x = orders(1);
    num_y = orders(2);
    num_t = orders(3);
    num_s = orders(4);

    st = zeros(basis.rows, basis.cols, 6);

    for x = 0:num_x-1
        for y = 0:num_y-1
            for t = 0:num_t-1
                for s = 0:num_s-1
                    k = x + (y * num_x) + (t * num_x * num_y) + (s * num_t*num_x*num_y) + 1;
%                     X = ColorMgetfilter(basis, angle, x+1, y, t);
%                     Y = ColorMgetfilter(basis, angle, x, y+1, t);
%                     T = ColorMgetfilter(basis, angle, x, y, t+1);

    %% for spectrum derivative. Start
                    X = ColorMgetfilter(basis, angle, x+1, y, t, s);
                    Y = ColorMgetfilter(basis, angle, x, y+1, t, s);
                    T = ColorMgetfilter(basis, angle, x, y, t+1, s);
                    S = ColorMgetfilter(basis, angle, x, y, t, s+1);

    %% for spectrum derivative. End
                    if (filterthreshold ~= 0)
%                         for i=1:3
%                             X.data(:,:,i) = X.data(:,:,i) .* (abs(X.data(:,:,i)) > filterthreshold);
%                             Y.data(:,:,i) = Y.data(:,:,i) .* (abs(Y.data(:,:,i)) > filterthreshold);
%                             T.data(:,:,i) = T.data(:,:,i) .* (abs(T.data(:,:,i)) > filterthreshold);
%                             S.data(:,:,i) = S.data(:,:,i) .* (abs(S.data(:,:,i)) > filterthreshold);
%                         end
                        X.data = X.data .* (abs(X.data) > filterthreshold);
                        Y.data = Y.data .* (abs(Y.data) > filterthreshold);
                        T.data = T.data .* (abs(T.data) > filterthreshold);
                        S.data = S.data .* (abs(S.data) > filterthreshold);
                    end                
                    st(:,:,1) = st(:,:,1) + (X.data(:,:,1) .* T.data(:,:,1) + X.data(:,:,2) .* T.data(:,:,2) + X.data(:,:,3) .* T.data(:,:,3))...
                        * weights(k);
                    st(:,:,2) = st(:,:,2) + (T.data(:,:,1).^2 + T.data(:,:,2).^2 + T.data(:,:,3).^2) * weights(k);
                    st(:,:,3) = st(:,:,3) + (X.data(:,:,1).^2 + X.data(:,:,2).^2 + X.data(:,:,3).^2) * weights(k);
                    st(:,:,4) = st(:,:,4) + (Y.data(:,:,1) .* T.data(:,:,1) + Y.data(:,:,2) .* T.data(:,:,2) + Y.data(:,:,3) .* T.data(:,:,3))...
                        * weights(k);
                    st(:,:,5) = st(:,:,5) + (Y.data(:,:,1).^2 + Y.data(:,:,2).^2 + Y.data(:,:,3).^2) * weights(k);
                    st(:,:,6) = st(:,:,6) + (X.data(:,:,1) .* Y.data(:,:,1) + X.data(:,:,2) .* Y.data(:,:,2) + X.data(:,:,3) .* Y.data(:,:,3))...
                        * weights(k);

%                     st(:,:,1) = st(:,:,1) + (X.data .* T.data) * weights(k);
%                     st(:,:,2) = st(:,:,2) + (T.data .* T.data) * weights(k);
%                     st(:,:,3) = st(:,:,3) + (X.data .* X.data) * weights(k);
%                     st(:,:,4) = st(:,:,4) + (Y.data .* T.data) * weights(k);
%                     st(:,:,5) = st(:,:,5) + (Y.data .* Y.data) * weights(k);
%                     st(:,:,6) = st(:,:,6) + (X.data .* Y.data) * weights(k);
                end
            end
        end
    end
%% first derivative Gaussian    
%     aa = zeros(5,1);
%     for i=-2:2
%         aa(i+3,1)=DG(i,1,1);
%     end
%     quotientfilter = aa*aa';
%% prewitt 
%     quotientfilter = ones(5);
%     quotientfilter(:, 1:2) = -1;
%     quotientfilter(1:2, 3) = -1;
%% average    
%     quotientfilter = ones(5)/25;
%% Gaussian
%     quotientfilter = fspecial('gaussian', [5 5], 2);

%% quotient filtering
%     st(:,:,1) = conv2(st(:,:,1), quotientfilter, 'same');
%     st(:,:,2) = conv2(st(:,:,2), quotientfilter, 'same');
%     st(:,:,3) = conv2(st(:,:,3), quotientfilter, 'same');
%     st(:,:,4) = conv2(st(:,:,4), quotientfilter, 'same');
%     st(:,:,5) = conv2(st(:,:,5), quotientfilter, 'same');
%     st(:,:,6) = conv2(st(:,:,6), quotientfilter, 'same');
    
%     st(:,:,1) = conv2(st(:,:,1), quotientfilter', 'same');
%     st(:,:,2) = conv2(st(:,:,2), quotientfilter', 'same');
%     st(:,:,3) = conv2(st(:,:,3), quotientfilter', 'same');
%     st(:,:,4) = conv2(st(:,:,4), quotientfilter', 'same');
%     st(:,:,5) = conv2(st(:,:,5), quotientfilter', 'same');
%     st(:,:,6) = conv2(st(:,:,6), quotientfilter', 'same');
%% Caculate velocity and reverse velocity    
    M0 = Mdefdiv(st(:,:,1), st(:,:,2), divisionthreshold);
    M1 = Mdefdiv(st(:,:,1), st(:,:,3), divisionthreshold) ....
        ./ (1 + (Mdefdiv(st(:,:,6), st(:,:,3), divisionthreshold)).^2);
    M2 = Mdefdiv(st(:,:,4), st(:,:,2), divisionthreshold);
    M3 = Mdefdiv(st(:,:,4), st(:,:,5), divisionthreshold)....
        ./ (1 + (Mdefdiv(st(:,:,6), st(:,:,5), divisionthreshold)).^2);
end

