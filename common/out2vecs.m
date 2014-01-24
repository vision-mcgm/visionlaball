function [Vx, Vy]=out2vecs(vel,angles)
	Vx=vel.*sin(angles*pi/180);
	Vy=vel.*cos(angles*pi/180);
end