parfor i=1:60
    %root='C:\Export\JobData1\VisionLabLibrary\Debug\'
    root='\\komodo\SharedData\Fintan\Debug\'
    cd(root);
    pwd
    c=clock;
    s=sprintf('%d-%d-%d-%d-%d-%.3f.txt',c(1:6));
    f=fopen(s,'w')
    f
    fprintf(f,'lolbears');
    fclose(f);
end