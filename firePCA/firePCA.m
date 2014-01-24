function [  ] = firePCA(  )
%Try and do some naive PCA on the fire images


d='\\komodo\SharedData\Fintan\Experiments\frames\normal\';
l=dir([d '*.bmp']);
n=size(l,1);

%Rows correspond to observations

for i=1:n
    i
    im=im2double(imread([d l(i).name]));
    data(i,:)=im(:);
end

[coeffs,scores]=princomp(data);

save([d 'out.mat'],'coeffs','scores');


end

