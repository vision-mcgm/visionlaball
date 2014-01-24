function SFILT  = DG(x, sigma, n)

gauss = exp(-(x^2/(4*sigma)))/sqrt(4*sigma*3.1415926);

H = 0;
for m = 0:floor(n/2)
    H = H + (-1)^m * ((2*x)^(n-2*m)/(4*sigma)^(n-m))/(factorial(m)*factorial(n-2*m));
end

H = factorial(n)*H;

SFILT = H*gauss;