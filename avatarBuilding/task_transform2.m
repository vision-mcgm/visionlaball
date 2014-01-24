function [ ok,tFin ] = task_transform2(transPathMatrix,transOutPathMatrix,cpstack)
%Takes a cell (in intermediate matrix form) whose first column contains
%paths and whose second and third contain source and target model numbers.
    
    tStart=tic;
    
    
    
    
    
    transPathCell=toCell(transPathMatrix);
    transOutPathCell=toCell(transOutPathMatrix);
   
    
    [mR mC] = size(transPathCell);
    
    %Rows,cols: refsets, images
    
   [h w c]=size(imread(transPathCell{1,1}));
    
  for i=1:mR %Iterate down the rows of the cell
      
      Ms=transPathCell{i,2};
      Mt=transPathCell{i,3};
      
      kpSource=squeeze(cpstack(:,:,Ms));
      kpTarget=squeeze(cpstack(:,:,Mt));
      
      %The following is taken from peng_affine_transform.m
      
      %  keypoints of source image
      KPLeftEyeCenter = mean(kpSource([1, 2], :));
KPRightEyeCenter = mean(kpSource([3, 4], :));
KPNoseCenter = kpSource(5,:);
KPMouthCenter = mean(kpSource([6, 7], :));

SourcePoints = [KPLeftEyeCenter; KPRightEyeCenter; KPMouthCenter];

%  keypoints of target image

      KPLeftEyeCenter = mean(kpTarget([1, 2], :));
KPRightEyeCenter = mean(kpTarget([3, 4], :));
KPNoseCenter = kpTarget(5,:);
KPMouthCenter = mean(kpTarget([6, 7], :));

TargetPoints = [KPLeftEyeCenter; KPRightEyeCenter; KPMouthCenter];

% Warp the image
ImgIn=imread(transPathCell{i,1});
ImgOut = peng_affine_warp(ImgIn, SourcePoints, TargetPoints);
imwrite(ImgOut, transOutPathCell{i}, 'bmp');

  end
    
    
    ok=1;
    tFin=toc(tStart);
    
% catch
%     
%     if 0
%     %BEGIN DEBUG SECTION
%     t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
%     fclose(t);
%     delete(t);
%     pause(10);
%     t=tcpip('0.0.0.0',7720,'NetworkRole','Server');
%     set(t,'Timeout',40);
%     %delete(t);
%     altixLog('worraworraWOOBLE2');
%     fopen(t);
%     mstring='';
%     while 1
%         if t.BytesAvailable
%             rawData = fread(t,1,'double');
%             if rawData==64
%                 
%                 execString=mstring;
%                 
%                 mstring = '';
%                 try
%                     e=evalc(execString)
%                     e
%                     e=serialiseString(e);
%                     fwrite(t,e,'double');
%                 end
%             else
%                 mstring=[mstring char(rawData)];
%             end
%         end
%     end
%     %END DEBUG SECTION
%     end
% end

end

