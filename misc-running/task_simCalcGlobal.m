function [  ] = task_simCalc(all,args )
%Do similarity calc
%args: 1 

global list;
global ims;
global gall;
gall=all;

%Init

list=zeros(1,all.n);

n=size(args,1);

nodeLog(all.node,'Go');

for i=1:1
    nodeLog(all.node,'Loading');
    root=getIm(args(i).root);
    target=getIm(args(i).target);
    nodeLog(all.node,'Loaded-');
    indices(1,root,target)=ssim_index(root,target);
    nodeLog(all.node,'DONE ssim');
    indices(2,root,target)=mean(mean(imabsdiff(root,target)));
    nodeLog(all.node,'done abs diff');
    indices(3,root,target)=norm(double(target-root));
end

nodeLog(all.node,'Done comparisons');
 save([all.outFolder 'results' num2str(all.node,'%03d') '.mat'],'indices');
save([all.outFolder 'results' num2str(all.node,'%03d') '.mat']);

nodeLog(all.node,'Stop');
end

function im=getIm(n)
%Get image from cache or load it
global list;
global ims;
global gall;

if list(n)==0
    ims{n}=rgb2gray(imread([gall.f gall.list(n).name]));
    list(n)=1;
end
im=ims{n};
end

