function [d_ltm0, d_ltm1, d_ltm2, SFILT, weights] = ColorMGenfilters(orders)
%MGenfilters Summary of this function goes here
%   Generate the spatial and temproal filters.

    tn = 23;
    alpha = 10;
    tau = 0.25;
    nfilt = 5;
    n = 23;
    sigma = 1.5;

    %% d_ltm0

    d_ltm0(1,1) = 0;
    for i=1:tn-1
        d_ltm0(i+1,1) = lntm(i,alpha,tau);
    end

    %% d_ltm1

    tem = 0;
    for i=1:tn-1
        tem = tem + d1ltm(i, alpha, tau);
    end
    d_ltm1(1,1) = 0;
    for i=1:tn-1
        d_ltm1(i+1,1) = d1ltm(i, alpha, tau) - tem/(tn-1) * 0;
    end

    %% d_ltm2

    tem = 0;
    for i=1:tn-1
        tem = tem + d2ltm(i, alpha, tau);
    end
    d_ltm2(1,1) = 0;
    for i=1:tn-1
        d_ltm2(i+1,1) = d2ltm(i, alpha, tau) - tem/(tn-1) * 0;
    end

    %% SFILT

    SFILT = COMPLEXARRAY(n,nfilt+1);
    for i=0:n-1
        si = i - (n-1)/2;
        for j=0:nfilt
            SFILT.data(i+1,j+1) = DG(si,sigma,j);
        end
    end
    
    %% weights
    
    zone = [11; 11; 11; 11];
    weights = colortalyorweight(orders, zone, 0);
end

