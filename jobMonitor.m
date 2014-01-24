function [  ] = jobMonitor( job )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

running=1;
while running
    if strcmp(job.tasks(1).state,'finished')
        job.tasks(1)
        return
    else
        job.tasks(1)
        pause(1);
        
    end
end

end

