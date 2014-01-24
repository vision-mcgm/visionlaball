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

nodeLog(all.node,['Go2 on ' num2str(n) ' args']);

sliceResults=cell(n,1);

for i=1:n
    
    nodeLog(all.node,['Comp ' num2str(args(i).root) ' ' num2str(args(i).target)]);
    root=getIm(args(i).root);
    target=getIm(args(i).target);
    %nodeLog(all.node,'Loaded-');
    indices(1,i)=ssim_index(root,target);
    %nodeLog(all.node,'DONE ssim');
    indices(2,i)=mean(mean(imabsdiff(root,target)));
   % nodeLog(all.node,'done abs diff');
    indices(3,i)=norm(double(target-root));
    
    %sliceResults{i,1}=indices(:,i);
end



nodeLog(all.node,'Done comparisons');
save([all.outFolder 'results' num2str(all.node,'%03d') '.mat'],'sliceResults');
 save([all.outFolder 'results' num2str(all.node,'%03d') '.mat'],'indices');
%save([all.outFolder 'results' num2str(all.node,'%03d') '.mat']);
%Definitely don't do this!

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