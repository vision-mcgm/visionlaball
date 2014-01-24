function [ sem ] = sem( data )
%Standard error of the mean

sem=std(data)/sqrt(length(data));


end

