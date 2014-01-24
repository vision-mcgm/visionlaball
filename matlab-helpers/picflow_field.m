function [ x ] = picflow_field( Vx,Vy )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

clf
[h w]=size(Vx);
image=ones(h,w);
x=picflow(image,Vx,Vy,3);
end

