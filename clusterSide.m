function [  ] = clusterSide(  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%SERVER

%t=tcpip('johnston10.psychol.ucl.ac.uk',40,'NetworkRole','Server');
t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
fclose(t);
delete(t);
pause(10);
t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
set(t,'Timeout',20);
%delete(t);
altixLog('worraworraWOOBLE2');
fopen(t);
fwrite(t,1234567,'double');
execloop(t);


end

