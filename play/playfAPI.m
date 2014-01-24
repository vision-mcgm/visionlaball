clear all

root = 'C:\Users\PaLS\Desktop\fintan\VisualStudio\TestAppConsole C++_copy(working)\';
files = 'data\a_out.txt';
coords = 'data\a_coords_mask.txt';


cd(root)

F = importdata([root files],',');
C = importdata([root coords]);

[Fr Fc]=size(F);
[Cr Cc]=size(C);

nPoints=38;


for i=1:Fr
    [tok,rem]=strtok(F{i},' ');
    fNames{i,1}=tok;
    fNames{i,2}=rem(2:end);
end


for i=1:Cr
    
    idx=round(C(i,1));
    Cadj(idx,:)=C(i,2:end);
end


for i=1:Fr
    fprintf('%i %i \n',i,Cadj(i,1));
    im=imread([root fNames{i,2}]); %This is a uint8
    if Cadj(i,1)~=0
        'worra'
        for j=1:nPoints
            im(round(Cadj(i,2*j)),round(Cadj(i,2*j-1)),1)=255;
        end
    end
    imshow(im);
    pause(0.1);
end