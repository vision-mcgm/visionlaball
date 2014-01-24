function [o1,o2,o3,o4] = task_diag()

o1=pwd;
mem=memory;
o2=mem.MaxPossibleArrayBytes/(2^20);
o3=mem.MemAvailableAllArrays/(2^20);

o4=which('task_collectMorphVectors');


o1=ls('C:\Export\');

end
