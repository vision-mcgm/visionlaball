function [output] = d2ltm(t, alpha, tau)

output = -2*((log(t/alpha))/(tau^2 * t))*d1ltm(t, alpha, tau) - (2/(t^2*tau^2) * (1-log(t/alpha)) * lntm(t, alpha, tau));