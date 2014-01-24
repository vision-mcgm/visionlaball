function [  ] = dbgLog( str )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s=clock;

readableDate=['Debug_' num2str(s(1)) '-' num2str(s(2)) '-' num2str(s(3)) '-' num2str(s(4)) '-' num2str(s(5)) '-' num2str(s(6))];

%save(['\\komodo.psychol.ucl.ac.uk\SharedData\fintan\Debug\' readableDate '.txt'],'str','-ascii');

str=strrep(str,'\','\\');
fid = fopen(['\\komodo.psychol.ucl.ac.uk\SharedData\fintan\Debug\' readableDate '.txt'], 'w');
fprintf(fid, str);
fclose(fid);
end

