function [o1,o2,o3,o4] = task_console()

o1=which('server');
mem=memory;
o2=mem.MaxPossibleArrayBytes/(2^20);
o3=mem.MemAvailableAllArrays/(2^20);

o4=which('task_warp');

end
