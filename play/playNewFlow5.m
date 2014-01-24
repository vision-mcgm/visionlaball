%Interpolates keypoint warp matrices into a full warp field.

%PREDATA: 240*200 matrices giving the keypoint matrices for each field
%(aligned to the reference faceframe).
%refFrameX,refFrameY set by playfAPI8

%We set a reference frame.



[meshX meshY]=meshgrid(1:240,1:200); %Create X and Y coords of the gridpoints in a 240*200 frame

for i=1:
    
    
    interpDisplacementX=interp2(refFrameX,refFrameY,thisDisplacementX,meshX,meshY);
    interpDisplacementY=interp2(refFrameX,refFrameY,thisDisplacementY,meshX,meshY);