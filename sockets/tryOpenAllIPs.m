t=tcpip('128.40.97.189',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{1}=t;
t=tcpip('128.40.97.181',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{2}=t;
t=tcpip('128.40.97.182',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{3}=t;
t=tcpip('128.40.97.183',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{4}=t;
t=tcpip('128.40.97.184',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{5}=t;
t=tcpip('128.40.97.185',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{6}=t;
t=tcpip('128.40.97.16',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{7}=t;
t=tcpip('128.40.97.187',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{8}=t;
t=tcpip('128.40.97.188',7720, 'NetworkRole', 'client');
set(t,'Timeout',1);
ts{9}=t;


for i=1:9
    try
        i
        fopen(ts{i});
        disp('Debug connection successfully established.');
        controller(ts{i});
        break
    end
end