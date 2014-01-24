function [ job ] = prepareJob(c,maxWorkers  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

sched=findResource();									% sched=findResource('scheduler','configuration','jobmanagerconfig0');
    job=createJob(sched);
    set(job,'MaximumNumberOfWorkers', maxWorkers);
    set(job,'MinimumNumberOfWorkers',1);
    
    %THIS IS THE IMPORTANT PATH-SETTING PART.
    paths={c.replicatedRoot,[c.replicatedRoot 'Code\matlab-helpers\'],[c.replicatedRoot 'Code\'],...
        [c.replicatedRoot 'Code\common\'],...
        [c.replicatedRoot 'Code\mcgm\'],...
       [c.replicatedRoot 'Code\avatarBuilding'] };		% UNC paths to any other folders needed by the workers to execute their tasks.
    set(job,'PathDependencies',paths);
end

