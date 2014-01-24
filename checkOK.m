function [  ] = checkOK( tasks )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

tasks{1}

for i=1:size(tasks,2)
    if size(tasks{i}.ErrorMessage,1)
		fprintf('Task %d has error message %s.\n',i,tasks{i}.ErrorMessage);
		good=0;
    end
end
    

