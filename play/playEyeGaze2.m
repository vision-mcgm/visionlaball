%Aligns everything to the eyes, on the reference faceframe

playEyeGaze_params %Set params

%Get file list
checkDir(out);
l=dir([in '*.JPG']);
n=size(l,1);

load([in 'kpts.mat']);



for i=1:n
    i
    
    %Matrices need to be n-by-2, here n is 2 so it's eye-by-axis
    %(row-by-col)
    
    input_points=[squeeze(allXs(i,:))' squeeze(allYs(i,:))'];
    t = cp2tform(input_points,ref_points,'nonreflective similarity');
   % t = cp2tform(ref_points,input_points,'nonreflective similarity');
  
   

%Now points are in the right format

im=imread([in l(i).name]);
imt=imtransform(im, t,'XData',[1 outW],'YData',[1 outH]);

thisName=l(i).name;
thisName=thisName(1:end-4);

imwrite(imt,[out thisName '.bmp' ],'bmp');
end


