function [ angle ] = Manglecalc(A0, A1, A2, A3)
%MANGLECALC Summary of this function goes here
%   Detailed explanation goes here
    angle = (atan2((A2+A3), (A0-A1)) * 180) / pi;
    angle = angle + +(angle >= 360) * (-360);
    angle = angle + +(angle <= 0) * 360;
end

