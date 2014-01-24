function [ output_args ] = task_incrMCGMGroup( args )
%Takes two lists of source/target pairs and dumps their warp vectors into
%an output folder. Pure MCGM only - no processing is done.
%args is a OP * PARAMS struct array


n=size(args,1);


for i=1:n
    sourceList(i,1).name=args(i).source; %Make sure these are colvecs
    targList(i,1).name=args(i).target;
   
end

%Params



mcgmcpp = 1.5;
mcgmconv = 23;
mcgmthresh = 0.1;

%Code
n=size(sourceList,1);




for op=1:n
    op
    
        sourceIm=imread(sourceList(op).name);
    targIm=imread(targList(op).name);
    
    
    sourceIm=im2double(sourceIm);
    targIm=im2double(targIm);
    [shot vel angles]=mcgm2(sourceIm,targIm,mcgmcpp,mcgmconv,mcgmthresh);
    
    save(args(op).output,'vel','angles');
    

   
end


    
end

