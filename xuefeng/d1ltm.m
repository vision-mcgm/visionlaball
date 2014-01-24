function [output] = d1ltm(t, alpha, tau)

output = -2*((log(t/alpha))/(tau^2 * t))*lntm(t, alpha, tau);

