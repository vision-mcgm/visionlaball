function [ theta ] = mcgm2rad( theta )
%Convert angles from the MCGM representation into radians
theta=mod((mod(theta-90,360))*(pi*2/360),2*pi);

end

