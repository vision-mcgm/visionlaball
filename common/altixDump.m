function [  ] = altixDump( var )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%root='C:\Export\JobData1\VisionLabLibrary\Debug\'

if isCluster
filename='\\komodo\SharedData\Fintan\Debug\altixDump.mat';
else
filename='\\komodo.psychol.ucl.ac.uk\SharedData\Fintan\Debug\altixDump.mat';   
filename
end
delete(filename);
save(filename,varname(var));


cd




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

function out = varname(var)
  out = inputname(1);
end
