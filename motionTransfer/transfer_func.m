function [ imgOut,imgComp ] = transfer_func( TPx,TPy,Texture,M_i,M_j,T,w,h,P_j,caric,compare )
%Transfers an expression from source to target

%Variable hookups


% (3) Affine transform for source morph vector X_if to TX_if
TX_if = Affine_Transform(TPx, TPy, Texture, T, w, h);
sourceVec = serialise(TPx, TPy, Texture);


% (4) Calculate relative morph vector of source frame
        TR_if = TX_if - M_i;
    
        % (5) Project to PCA space of target identity, find PCA
        % coefficients
        Q_ifj = P_j' * TR_if;
        
        %Caricature
        Q_ifj = Q_ifj * caric;
        
        % (6) Calculate relative morph vector of target identity
        QR_ifj = P_j * Q_ifj;
    
        % (7) Calculate the morph vector of target identity
        R_ifj = QR_ifj + M_j;
    
    imgOut = morphvec2image(R_ifj,w,h);
    
   % 
    
    
    if compare
        imgComp=zeros(h,w*2,3);
        imgComp(:,w+1:w*2,:)=imgOut;
        I1=morphvec2image(sourceVec,w,h);
        imgComp(:,1:w,:)=I1;
        %outPath=[rightPath(c,c.dirOutput) 'comp' num2str(j,'%03i') '.bmp'];
    
    %imwrite(comp, outPath,'bmp');
    end

end

