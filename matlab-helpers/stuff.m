function [ out ] = stuff( vec,h,w )
%Reshapes a MATRIX which has been deserialised by a(:)

veclength=h*w;
%Split the vector into 3 parts, X y and texture, and reshape them into
%matrices

out=reshape(vec,h,w);


end

