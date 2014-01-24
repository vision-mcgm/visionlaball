function [  ] = task_mcgm_group( sliceArgStruct )
n=size(sliceArgStruct,1);

mcgmcpp = 1.5;
	mcgmconv = 23;
	mcgmthresh = 0.1;

for i=1:n
    target=sliceArgStruct(i).target;
    ref=sliceArgStruct(i).ref;
    out=sliceArgStruct(i).out;
    
    target=im2double(rgb2gray(imread(target)));
    ref=im2double(rgb2gray(imread(ref)));
    
  
        altixLogFile(num2str(i) ,pwd);
   
    [shot vel angles]=mcgm2(ref,target, mcgmcpp, mcgmconv, mcgmthresh);
    
    save(out,'shot','vel','angles');
    
end


end

