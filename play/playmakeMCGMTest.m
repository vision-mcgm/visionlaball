of='W:\Fintan\Data\viscosity\tst2\'
checkDir(of);
n=60

y=11;
x=50;

for i=1:n
    i
    this=ones(100,100);
    this(y-10:y+10,x-1:x+10)=1;
    y=y+0;
    imwrite(this,[of num2str(i,'%03d') '.png'],'png');
end