function [o1,o2,o3,o4] = task_diag()
% 
o1=0;
o2=0;
o3=0;
o4=1;

%error(evalc('ver'));
%cd \\komodo\SharedData\Fintan\Debug\

%system('\\komodo\SharedData\Fintan\Debug\depends\depends.exe /c /f:1 /od:\\komodo\SharedData\Fintan\Debug\dreport_yprime.dwi yprime.mexw64');
%system('\\komodo\SharedData\Fintan\Debug\depends\depends.exe /c /f:1 /od:\\komodo\SharedData\Fintan\Debug\dreport_colortaylorweight.dwi colortaylorweight.mexw64');
%system('\\komodo\SharedData\Fintan\Debug\depends\depends.exe /c /f:1 /od:\\komodo\SharedData\Fintan\Debug\dreport_mcgm2.dwi mcgm2.mexw64');


%error(which('task_collectMorphVectors_Marion_2'))

%o1=(yprime(1,[1 2 3 4]))

% c=config('mitch.pca');
% 
%cd('\\komodo.psychol.ucl.ac.uk\SharedData\')
o1=which('task_getMeanFlow');
o2=path;
% f=[rightPath(c,c.dirPCAModel) 'all\PCAModel.mat'];
 %o3=ls('\\komodo.psychol.ucl.ac.uk\SharedData\') %Fintan\Data\rathore\DevDat\')


 %o4 = evalc('system(''hostname'');');
% %load(f);
% altixLog('//wo/r.ra')
% %o4=pcTrimmed*pcTrimmed';
%clusterSide();  
% %o4=system('ping johnston10.psychol.ucl.ac.uk');

end
