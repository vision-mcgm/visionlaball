function [CI,interval] = mtMeanCI(muList,pc)
% Takes a list of means and a required confidence level (e.g. 0.95) and returns
% the upper and lower bounds of the confidence interval. If no confidence level
% suppied, 0.95 is used by default.
%CI is the real value, interval is the value relative to that mean.

if nargin < 2
    pc = 0.95;
end

c = -tinv((1-pc)/2,length(muList)-1);
interval = c*std(muList)/sqrt(length(muList));
mu = mean(muList);
CI = [mu-interval,mu+interval];

%interval=std(muList);
%interval=interval/sqrt(length(muList));