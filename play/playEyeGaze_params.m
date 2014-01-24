%Sets params

%Parameters:

set='rotated-centre-edit\'; %Set this, must have trailing slash

%in= ['W:\Fintan\Data\eyegaze\input\' set];
% out=['W:\Fintan\Data\eyegaze\readyl\' set];

in= checkSlash(['W:\Fintan\Data\eyegaze\delivered\some_more_images']);
 out=checkSlash(['W:\Fintan\Data\eyegaze\delivered\resized_some_more_images']); %Check slash for later use
 
 
 checkDir(in);
 checkDir(out);

%Default faceframe

%refX=[100;300]; %Colvec
%refY=[160;160]; %Colvec

%ref_points =[100 160; 300 160]; %These need to be n-by-dim, n is 2, dim is 2 (x and y)
%ref_points =[35 60; 65 60] % This is [leftX leftY; rightX rightY);

ref_points =[70 120; 130 120] %For 240

outH=240;
outW=200;


%Image-left eye, then image-right eye

%Start code