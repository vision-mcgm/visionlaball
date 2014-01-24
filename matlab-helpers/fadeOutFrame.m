function [ J ] = fadeOutFrame( I,fX,fY )
%Fades out an image outside the exterior of a polygon

fX=round(fX);
fY=round(fY);

[iy ix c]=size(I);
J=uint8(zeros(iy,ix,3));

minX=round(min(fX));
maxX=round(max(fX));
minY=round(min(fY));
maxY=round(max(fY));

%listY=1:iy;
%listX=1:ix;

%listX=minX:maxX;
%mistY=minY:maxY;




it=1;
for i=minX:maxX
    
    for j=minY:maxY
    coordsX(it)=i;
    coordsY(it)=j;
    it=it+1;
    end
end

in=inpolygon(coordsX,coordsY,fX,fY);

it=1;
for i=minX:maxX
    
    for j=minY:maxY
    %iN(coordsY(it),coordsX(it))=in(it);
    if in(it)~=0
        %I(j,i,:)=0;
        J(j,i,:)=I(j,i,:);
    end
    it=it+1;
    end
end


% for x=1:ix
%     for y=1:iy
%         if inpolygon(x,y,fX,fY)
%             J(y,x,:)=I(y,x,:);
%         end
%     end
% end

end

