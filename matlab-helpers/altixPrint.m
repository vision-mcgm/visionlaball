function [  ] = altixPrint( m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%root='C:\Export\JobData1\VisionLabLibrary\Debug\'
if isCluster
filename='\\komodo\SharedData\Fintan\Debug\altixLog.txt';
fid=fopen(filename,'a+');
fprintf(fid,[m '\n']);
fclose(fid);
end






%     root='\\komodo\SharedData\Fintan\Debug\';
%     %root='W:\Fintan\Debug\';
%     cd(root);
%    
%     c=clock;
%     s=sprintf('%d-%d-%d-%d-%d-%.3f.txt',c(1:6));
%     f=fopen(s,'w');
%     %Double up the bloody escape sequences
%     m=strrep(m,'\','\\');
%     fprintf(f,m);
%     fclose(f);

end

