function [ c ] = toCell( m )
%Converts 3D char matrix padded with @ to 2D cell array of strings

[h w d]=size(m);

for ih=1:h
    for iw=1:w
        acc='';
        for id=1:d
            if m(ih,iw,id)~=64
                acc=[acc m(ih,iw,id)];
            end
        end
        if size(acc,2)
            c{ih,iw}=acc;
        end
    end
end
            

end

