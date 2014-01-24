%playCluster1
%Experiments with clustering in PCA spaces


%Parameters
n=19; %PCs


%Code

for i=1:200
figure(1)
[x y]=ginput(1)
vec=zeros(n,1);
vec(1:2)=[x y];
f=faceFromLoadings(c,vec);
figure(2);
imshow(f);

end


