%Analyses results from entire experiment

%Params

f='X:\VisionLabLibrary\output\';
subjects={'aa','bb2','bs','ccm','ch','jm'};
conditions=6;
%Code

%Clears

%Loop over subjects

%Knowledge
s=length(subjects);
means=zeros(s,conditions,9);

f=checkSlash(f);

%Code
for is=1:s
    l=dir([f 'subject_' subjects{is} '*.dat']);
    
    %There is no number-sorting problem here because there are under ten
    %numbers.
    for ic=1:conditions
        load=readdata([f l(ic).name]);
        for iStim=1:9
        means(ic,iStim)=means(ic)+load(iStim,2);
        data(is,ic,iStim)=load(iStim,2);
        end
    end
    
end