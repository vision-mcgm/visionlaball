%Takes a directory of folders. Takes every nth file from each folder and
%puts it into a new folder.

d='W:\Fintan\Data\avatars\male1\input\'

r=10; %take every rth file

d1=dir(d);
nf=size(d1,1);
%Remember dirs are column vectors

for i=1:nf
    i
    if not(strcmp(d1(i).name,'.')) && not(strcmp(d1(i).name,'..'))
        if d1(i).isdir
            
            d2 = dir([d d1(i).name '\*.bmp'])
            
            %Sampling loop
            
            dOut = [d d1(i).name '_subsample'];
            
            checkDir(dOut);
            
            for j=1:size(d2,1)
                j
                if mod(j,r)==0
                    movefile([d d1(i).name '\' d2(j).name], [dOut '\' d2(j).name]);
                end
            end
        end
    end
end