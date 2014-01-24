function [ ok,tFin ] = task_warpMorphMean_matrix(imgPathMatrix,refPathMatrix,outPathMatrix)
%Takes a cell array of image paths (refsets,images) and a COLUMN cell of reference images.
%A refset is a set of images with one reference to be morphed.
    
    tStart=tic;
    
    
    % Define sharpening filter (inverse Laplacian with default (0.2) alpha
% parameter)
fil = fspecial('unsharp');
    
    
    imgPathCell=toCell(imgPathMatrix);
    refPathCell=toCell(refPathMatrix);
    outPathCell=toCell(outPathMatrix);
    
    [mR mC] = size(imgPathCell);
    
    %Rows,cols: refsets, images
    
   [h w c]=size(imread(imgPathCell{1,1}));
    
    for iR=1:mR
        %Loop over refsets
        %Do the individual warps
        clear TVx
        clear TVy
        
        images=zeros(mC,h,w,c);
        
        for iC=1:mC
            
            if size(imgPathCell{iR,iC},1)
                [Vx,Vy]=warp_util_file(imgPathCell{iR,iC},refPathCell{iR,1});
                images(iC,:,:,:)=imread(imgPathCell{iR,iC});
                
                TVx(iC,:,:)=Vx;
                TVy(iC,:,:)=Vy;
            end
            
        end
        
        %Get the mean flow
        [ Mx,My,rMx,rMy ] = getMeanFlow_util_data(TVx,TVy);
        
        %This function returns MORPH VECTORS, whose warp components are
        %given in NEW PIXEL POSITIONS, not warp fields.
        [TMx,TMy,T_img,Mx,My,Mtex]=getMorphVectors_util_data(TVx,TVy,images,rMx,rMy);
        

        
        im=morphvec2image_components_pixelpos(Mtex,Mx,My,h,w);
        im = imfilter(im, fil, 'replicate');
        imwrite(im,outPathCell{iR,1},'bmp');
        
        
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

