name='armstrong';
c.root = ['C:\Users\PaLS\Desktop\fintan\VisualStudio\TestAppConsole C++_copy(working)\data\' name '\'];
root=c.root;
c.files = 'a_out.txt';
c.coords = '\a_coords_mask.txt';
%c.outFolder=[root 'processed\'];
c.mask = '\a_mask.txt';

root=c.root;
files=c.files;
coords=c.coords;
outFolder=['W:\Fintan\Data\motion\processed\' name '\'];
mask=c.mask;



%Common bits for every part of the pipeline

root2.l='W:\Fintan\Data\';
root2.r='\\komodo\SharedData\Fintan\'

h=120;
w=100;