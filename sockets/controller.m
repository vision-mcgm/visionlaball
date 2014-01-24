function [  ] = controller( t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

string='';

while 1
    
    if t.BytesAvailable
        rawData=fread(t,1,'double');
        string = [string rawData];
    else
        realString=char(string);
        string='';
        disp(realString);
        
        in=input('Prompt?','s');
        if size(in,2)
        in = [in '@'];
        
        fwrite(t,in,'double');
        pause(0.5);
        end
    end
    %pause(0.5)
    
end



end

