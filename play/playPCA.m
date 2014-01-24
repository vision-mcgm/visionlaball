%Do a PCA on some images, naively, without warp fields

%Parameters
in='W:\Fintan\Data\eyegaze\ready\direct-left\';

h=120;
w=100;


%Go

l=dir([in '*.bmp']);
n=size(l,1);

%Load images

for i=1:n
    i
    im=imread([in l(i).name]);
    
    vec(:,i)=im(:)'; %This is how it's done in the pipeline
    %Matrix is dimensions-data, same as in pipeline,
    
    %Remember the data matrix is not mean-relative; The mean is taken away
    %shortly.
end
    data=vec;
    meanVec = mean(data,2);
    
    %Reproduce the image
    
    final = reshape(meanVec,[h, w, 3]);
    
    