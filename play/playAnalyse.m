
f='Z:\VisionLabLibrary\output\';
subjects={'aa','bb2','bs','ccm','ch','jm'};
conditions=6;
nSubjects=6;
d=f;


 priors.m_or_a = 'None';
 priors.w_or_b = 'None';
 priors.lambda = 'Uniform(0,.1)';
 priors.gamma  = 'Uniform(0,.1)';

 nData=10;
    
    conditions={'dp-2_inv1',...
        'dp-2_inv2',...
        'dp-2_inv3',...
        'adp2_inv1',...
        'adp2_inv2',...
        'adp2_inv3'};
    nConditions=length(conditions);
    conditionNames={'Bottom, upright',...
        'Bottom, inverted',...
        'Bottom, opposite',...
        'Top, upright',...
        'Top, inverted',...
        'Top, opposite'};
    
   

for iSubjects=1:nSubjects
    

subjects(iSubjects)
    

l=dir([d 'subject_' subjects{iSubjects} '*.mat']);
 n=size(l,1);
for i=1:n
    l(i).name
end
    
   

    for i=1:n
        shortNames{i}=l(i).name(end-12:end);
    end
    
    for i=1:nConditions
        for j=1:nConditions
            if strcmp(shortNames{j}, [conditions{i} '.mat'])
                conditionFiles{i}=load([d l(j).name]);
                conditionPsignifitFiles{i}=toPsignifit(conditionFiles{i});
                pd=conditionPsignifitFiles{i};
                rF=BayesInference(pd,priors,'nafc',1);
               % GoodnesOfFit(rF);
               structs{iSubjects,i}=rF;
                %pause(3);
               % pRes{iSubjects,i}=pfit(pd,'n_intervals',1);
                conditionNamesCheck{i}=[d l(j).name];
            end
        end
    end
    
    %Confirmed working.
    
    %Do plots
    
    for i=1:nConditions
        h=subplot(2,3,i);
        
        plot(squeeze(conditionPsignifitFiles{i}(:,2)));
        title(h,conditionNames{i});
    end
    pause(1);
end
%
% for i=1:n
%     load{i}=readdata([d l(i).name]);
% end
%
% hold on
%
% subplot(1,3,1);
%
% for i=1:n
%     plot(load{i}(:,2));
% end
%
% clear means
% means=zeros(1,9);
% for i=1:n
%     for j=1:9
%         means(j)=means(j) + load{i}(j,2);
%     end
% end
%
% means=means/n;