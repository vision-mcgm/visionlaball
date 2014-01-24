D = 'W:\Fintan\Data\radboud\NeutralFaceSpaceRadboud\'
out='W:\Fintan\Data\radboud\NeutralFaceSpaceRadboud\bmp\'

checkDir(out);

l=dir([D '*.jpg']);
n=size(l,1);

for i=1:n
    i
    im=imread([D l(i).name]);
    imwrite(im,[out l(i).name(1:end-4) '.bmp']);
end