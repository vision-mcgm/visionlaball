function [  ] = nodeLog( n,m )

%root='C:\Export\JobData1\VisionLabLibrary\Debug\'
    root='\\komodo\SharedData\Fintan\Debug\NodeLogs\';
    %root='W:\Fintan\Debug\';


   
    c=clock;
    stamp=sprintf('%d-%d-%d-%d-%d-%.3f: ',c(1:6));
    s=sprintf(['Node' num2str(n,'%03d') '.txt']);
    f=fopen([root s],'a');
    %Double up the bloody escape sequences
    m=strrep(m,'\','\\');
    m=[stamp m '\n'];
    fprintf(f,m);
    
    fclose(f);

end

