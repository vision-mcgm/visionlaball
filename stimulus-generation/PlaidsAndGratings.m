dirOut=['D:\fintanData\Ben MCGM programming\plaids2\'];
dirOutG=['D:\fintanData\Ben MCGM programming\gratings2\'];
checkDir(dirOut);
checkDir(dirOutG);

sf=10 %Spatial frequency in cycles per IMAGE
aDeg=45; %Angle (on plaids, 45 produces an equally spaced plaid, other values produce plaids with different aspect ratios)
a=(aDeg/180)*pi;
p=50

clear im

si=200 %Size of image
sj=200


p_it=1;
for p=1:100
    
    p=(2*pi/100)*p;

   % p=p_it;
for i=1:si
    for j=1:sj
        
        im(i,j)=sin(cos(a)*((i*sf*2*pi)/si) +sin(a) *((j*sf*2*pi)/sj) +p)  +sin(cos(a) * ((i*sf*2*pi)/si) - sin(a) * ((j*sf*2*pi)/sj) + p);
        
    end
end

%imagesc(im)


clear im2

for i=1:si
    for j=1:sj
        im2(i,j)=sin(cos(a)*((i*sf*2*pi)/si) +sin(a) *((j*sf*2*pi)/sj) +p)  +sin(cos(a) * ((i*sf*2*pi)/si) - sin(a) * ((j*sf*2*pi)/sj) + p)*0;
    end
end
%imagesc(im2)

imwrite(imScale(im2'),[dirOutG 'frame' num2str(p_it,'%03d') '.bmp']);
imwrite(imScale(im),[dirOut 'frame' num2str(p_it,'%03d') '.bmp']);


%pause(0.1)
p

p_it=p_it+1;
end