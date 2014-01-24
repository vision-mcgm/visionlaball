function [output] = lntm(t, alpha, tau)

output = exp(-(log(t/alpha)/tau)^2)/(sqrt(3.141592)*alpha*tau*exp((tau^2)/4));
