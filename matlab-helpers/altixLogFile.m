function [  ] = altixLogFile(file, m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%root='C:\Export\JobData1\VisionLabLibrary\Debug\'
    root='\\komodo\SharedData\Fintan\Debug\';
    %root='W:\Fintan\Debug\';
    
   
    c=clock;
    s=sprintf('%s.txt',file);
    f=fopen([root s],'w');
    %Double up the bloody escape sequences
    m=strrep(m,'\','\\');
    fprintf(f,m);
    fclose(f);

end

