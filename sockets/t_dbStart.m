function [] = t_dbStart()
% Server role - wait for TCP comms

 tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');
 set(tcpipServer,'OutputBufferSize',s.bytes);
 fopen(tcpipServer);
end
