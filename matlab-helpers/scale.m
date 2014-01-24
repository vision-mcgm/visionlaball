function [ m ] = scale( m )
%Scales a matrix (up to 2D) to between one and zero


bottom=min(min(m));

m=m-bottom;
top=max(max(m));
m=m/top;


end

