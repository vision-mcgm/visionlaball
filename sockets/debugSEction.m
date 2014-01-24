%BEGIN DEBUG SECTION
t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
fclose(t);
delete(t);
pause(10);
t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
set(t,'Timeout',40);
%delete(t);
altixLog('worraworraWOOBLE2');
fopen(t);
mstring='';
while 1
if t.BytesAvailable
rawData = fread(t,1,'double');
if rawData==64
    
    execString=mstring;
    
    mstring = '';
    try
    e=evalc(execString)
    e
    e=serialiseString(e);
    fwrite(t,e,'double');
    end
else
mstring=[mstring char(rawData)];
end
end
end
%END DEBUG SECTION