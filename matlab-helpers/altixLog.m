function [  ] = altixLog( m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%root='C:\Export\JobData1\VisionLabLibrary\Debug\'
    root='\\komodo\SharedData\Fintan\Debug\';
    %root='W:\Fintan\Debug\';

    c=clock;
    s=sprintf('%d/%d/%d-%d:%d-%.3f.txt',c(1:6));
    fname='altixLog.txt';
    f=fopen([root fname],'a');
    %Double up the bloody escape sequences
    m=strrep(m,'\','\\');
    m=[m '\n'];
    fprintf(f,m);
    fclose(f);

end

