function [  ] = execloop( t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here





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

end