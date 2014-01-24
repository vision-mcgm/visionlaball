function []=destroyMyJobs(uname)
r=findResource;
%all_jobs=get(r,'Jobs')
all_jobs=findJob(r,'UserName',uname);
%all_jobs=findJob(r);
n=size(all_jobs,1);
if size(all_jobs,1)~=0
    disp(['Destroying ' num2str(n) ' jobs.']);
    destroy(all_jobs)
else
    disp('No jobs.')
end
end