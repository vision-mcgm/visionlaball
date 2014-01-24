%Averages texture and transfers. This will only capture some muscle
%movement as everything has been aligned onto eyes and mouth.

srcDir='W:\Fintan\Data\motion\processed\atkinson\'

list=dir([srcDir '*.bmp']);
l=size(list,1);

for i=1:l
  
    i
    
    if i==1
        acc=im; %First iteration
    end
   im= imread([srcDir list(i).name]);
   im=double(im);
   im=im/255;
    images{i}=im;
    
    acc=acc+im;
    
end

acc=acc/l;

%Mean-rel

for i=1:l
    %relImages{i}=images{i}-acc;
   % imagesc(relImages{i});
   imshow(imScale(relImages{i}));
    pause(0.04);
end

for i=1:l
    imb(:,:,i)=binarise(images{i});
   % pause(0.04);
end