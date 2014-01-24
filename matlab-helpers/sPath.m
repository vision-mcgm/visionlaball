function [ y ] = sPath( x )
global local


if local
    y=x.l;
else
    y=x.r;
end
end

