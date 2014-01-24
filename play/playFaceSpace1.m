
%Batch convert jpgs to bmps

root='W:\Fintan\Data\faceSpace\fei\'
outFolder='W:\Fintan\Data\faceSpace\fei\input\'

checkDir(outFolder);

cd(root)

%F = importdata([root files],',');
%C = importdata([root coords]);

%[Fr Fc]=size(F);
%[Cr Cc]=size(C);

nPoints=38;
nGPoints=6;


% for i=1:Fr
%     [tok,rem]=strtok(F{i},' ');
%     [tok2,rem2]=strtok(rem,' ');
%     fNames{i,1}=tok;
%     fNames{i,2}=rem(4:end)
%     %fNames{i,2}=rem2(2:end);
% end

fNames=dir([root '*.jpg']);
Nf=size(fNames,1);


for i=1:Nf
    i
    I=imread([root  fNames(i).name]);
    thisName=fNames(i).name;
    thisName=thisName(end-3:end); %Remove bmp
    imwrite(I,[root 'img' num2str(i-1,'%06d') '.bmp'],'bmp');
end