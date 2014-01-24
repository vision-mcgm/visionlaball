function [  ] = autoCropAndResize( c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global props;
global h;
global v;

frameDir=rightPath(c,c.dirBitmapsBeforeResize);
sourceDir=rightPath(c,c.dirSourceBitmaps);
frameList=dir([frameDir '*.bmp']);

if ~isdir([sourceDir])
    mkdir([sourceDir]);
end

PCADir=[rightPath(c,c.dirPCAModel)];									% Defines 'Test2\mitchPCAc\' for use on the workers.
if ~isdir(PCADir);										% Create the PCADir folder on the local mounted drive (called mitchPCAc) if it does not exist.
    mkdir(PCADir);
end
warpDir=[PCADir 'warp'];								% Defines 'Test1\mitchPCAc\warp';
if ~isdir([PCADir 'warp'])    							% Create the warp folder (called warp, below mitchPCA) if it does not exist.
    mkdir([PCADir 'warp']);
end
allDir=[PCADir 'all']; 									% Defines 'Test2\mitchPCAc\all';
if ~isdir([PCADir 'all'])
    mkdir([PCADir 'all']);
end
morphDir=[PCADir 'morph'];								% Defines 'Test2\mitchPCAc\morph';
if ~isdir([PCADir 'morph'])
    mkdir([PCADir 'morph']);
end

firstFrame=imread([frameDir frameList(1).name]);

greyFrame=rgb2gray(firstFrame);
pos=fdlibmex(greyFrame,-4);
faceX=pos(1);
faceY=pos(2);
props.x=faceX;
props.y=faceY;
props.dx=0;
props.dy=0;
props.ex=20;
props.ey=20;

realW=size(firstFrame,2);
realH=size(firstFrame,1);
v.realW=realW;
v.realH=realH;

fprintf('Go into the figure window just created and use the arrows to move the ellipse and shift-arrows to alter its size. Then come back to this window and hit return.\n');

h=figure( 'Position',[560 728 realW realH],'KeyPressFcn',@(obj,evt)evtHandle(evt,firstFrame));
image(firstFrame);

p=pos;
for j=1:size(p,1)
        r = [p(j,1)-p(j,3)/2,p(j,2)-p(j,3)/2,p(j,3),p(j,3)*1.5];
        rectangle('Position', r, 'EdgeColor', [1,0,0], 'linewidth', 2);
        caption=['\color{red}' num2str(j)];
        text(p(j,1),p(j,2),caption,'FontSize',30);
end
    
if size(p,1)==0
        cprintf('err','No faces have been detected for image! Interpolating (well, you need to write the interpolation code really....\n');
    else if size(p,1)>1
            cprintf('err','Multiple faces detected for image! Showing them all. Please choose the correct one.\n');
            n=input('Enter the number of the correct face:\n');
            props.x=p(n,1);
            props.y=p(n,2);
            
        else
            
            cprintf('green','OK.\n');
        end
        
    end

ellipse(props.ex,props.ey,0,props.x+props.dx,props.y+props.dy);
%maskedFrame=wipeOval(firstFrame,faceX,faceY,20,20);

set(h,'Position',[560 728 realW realH]);

in=input('Continue?','s');

posFile=[rightPath(c,c.dirPCAModel) 'all\faceDimensions'];
faceDimensions=props;
save(posFile,'faceDimensions');

for i=1:c.frames
    fprintf('Face detecting frame %d...',i);
    thisFrame=imread([frameDir frameList(i).name]);
    greyFrame=rgb2gray(thisFrame);
    p=fdlibmex(greyFrame,-4);
    
    imshow(greyFrame);
    for j=1:size(p,1)
        r = [p(j,1)-p(j,3)/2,p(j,2)-p(j,3)/2,p(j,3),p(j,3)*1.5];
        rectangle('Position', r, 'EdgeColor', [1,0,0], 'linewidth', 2);
        caption=['\color{red}' num2str(j)];
        text(p(j,1),p(j,2),caption,'FontSize',30);
    end
    
    if size(p,1)==0
        cprintf('err','No faces have been detected for image %d! Using last value. (well, you need to write the interpolation code really....\n',i);
        pos(i,:)=pos(i-1,:);
    else if size(p,1)>1
            %Find closest face to last detected face
            if i>1
                clear d
            for face=1:size(p,1)
                lastX=pos(i-1,1);
                lastY=pos(i-1,2);
                d(face)= sqrt(  (p(face,1)-lastX)^2 + (p(face,2)-lastY)^2 );
            end
            [value,index]=min(d);
            fprintf('Multiple faces, face %d is closest to the previous good face so Im choosing that.\n',index);
            pos(i,:)=p(index,:);
                else
            cprintf('err','Multiple faces detected for image %d! Showing them all. Please choose the correct one.\n',i);
            n=input('Enter the number of the correct face:\n');
            pos(i,:)=p(n,:);
            
            end
        else
            pos(i,:)=p;
            cprintf('green','OK.\n');
        end
        
    end
    
    ellipse(props.ex,props.ey,0,pos(i,1)+props.dx,pos(i,2)+props.dy,'g');
    pause(1);
    
    
    posFile=[rightPath(c,c.dirPCAModel) 'all\facePositions'];
    facePositions=pos;
    save(posFile,'facePositions');
    
    % for i=1:c.frames
    %     fprintf('Processing %d...\n',i);
    %     thisFrame=imread([frameDir frameList(i).name]);
    %     greyFrame=rgb2gray(thisFrame);
    %     pos=fdlibmex(greyFrame,-4);
    % faceX=pos(1);
    % faceY=pos(2);
    % maskedFrame=wipeOval(thisFrame,faceX+props.dx,faceY+props.dy,props.ex,props.ey);
    % imshow(maskedFrame);
    % newImage=uint8(zeros(c.h,c.w,3));
    % newImage(50-props.ey:50+props.ey,60-props.ex:60+props.ex,:)=...
    %     maskedFrame(faceY-props.ey:faceY+props.ey,faceX-props.ex:faceX+props.ex,:);
    % imwrite(newImage, [rightPath(c,c.dirSourceBitmaps) 'frame' num2str(i) '.bmp'],'bmp');
    % end
    
end

resizeFromDataFile(c);

end

function o=evtHandle(evt,firstFrame)
global props;
global h;
global v;
%disp(evt);
tic;
redraw=0;
if size(evt.Modifier,2)
    if strcmp(evt.Modifier,'shift')
        switch evt.Key
            case 'uparrow'
                props.ey=props.ey+1;
                redraw=1;
            case 'downarrow'
                props.ey=props.ey-1;
                redraw=1;
            case 'rightarrow'
                props.ex=props.ex+1;
                redraw=1;
            case 'leftarrow'
                props.ex=props.ex-1;
                redraw=1;
        end
    end
else
    switch evt.Key
        case 'uparrow'
            props.dy=props.dy-1;
            redraw=1;
        case 'downarrow'
            props.dy=props.dy+1;
            redraw=1;
        case 'rightarrow'
            props.dx=props.dx+1;
            redraw=1;
        case 'leftarrow'
            props.dx=props.dx-1;
            redraw=1;
    end
    
    
end
if redraw
    figure(h);
    clf(h);
    image(firstFrame);
    ellipse(props.ex,props.ey,0,props.x+props.dx,props.y+props.dy);
    %maskedFrame=wipeOval(firstFrame,props.x+props.dx,props.y+props.dy,props.ex,props.ey);
    
    set(h,'Position',[560 728 v.realW v.realH]);
end
fprintf('Redraw takes %d secs.\n',toc);


end

