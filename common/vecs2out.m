function [ vel,angles ] = vecs2out(x,y  )
% To downpointing +- ACW polar coords
% To y-downpointing Cartesian coords

vel=sqrt( (x).^2 + y.^2);
angles=atan2(-y,x);
angles=rot90(angles,3);
angles=angles/(pi/180) ;

end

