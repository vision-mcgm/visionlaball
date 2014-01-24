function [ out ] = Mdefdiv(A, B, divth)
%MDEFDIV Summary of this function goes here
%   Detailed explanation goes here

    out = A ./ B;
    out = out .* ((abs(A) > divth) & (abs(B) > divth));
%     out = out .* (abs(A) > divth);
%     out = out .* (abs(B) > divth);
end

