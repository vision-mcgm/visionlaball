function [  ] = collectLogs(  )
%Collects all the node logs and saves them to a file
%We can't save them all in the same file to begin with because they're
%asynchronously written by the nodes, so characters from one node get
%interleaved with characters from another.

f='W:\Fintan\Debug\NodeLogs\';
fout='W:\Fintan\Debug\AllNodesLog.txt';

l=dir([f '*.txt']);

n=size(l,1);
outID=fopen(fout,'w');

for i=1:n
    fid=fopen([f l(i).name]);
    node=l(i).name(5:7);
    go=1;
    while go
        line=fgetl(fid)
        if ~ischar(line)
            go=0; 
        else
            fprintf(outID,'%s    %s\n',node,line);
        end
    end
    
    fclose(fid);
end

fclose(outID);


%delete(fout);
%save(

end

