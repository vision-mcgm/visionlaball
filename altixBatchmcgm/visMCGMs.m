function [  ] = visMCGMs(  )
%Visualise incremental mcgm fields

%Params
n=1000;
f='W:\Fintan\Data\fireMCGMs\';

%Code

for i=1:n
    i
    file=[f num2str(i,'%04d') '.mat'];
    figure(1)
    try
l=load(file);


plotDual(l.shot,l.vel,l.angles);
    catch
        fprintf('%d missing!\n',i);
    end
    
    pause(0.5);
end

end

