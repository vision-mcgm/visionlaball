function [work] = ColorMgetfilter(basis, angle, x, y, t, s)
%MGETFILTER Summary of this function goes here
%   Detailed explanation goes here

     work = COLORIMAGE(basis.rows, basis.cols, 1);   
%    work = IMAGE(basis.rows, basis.cols, 1);
    weights = zeros(x + y + 1,1);
    
    angle = -angle - pi/2;
    
    for i = 0:x
        for j = 0:y
            weights(x+y-i-j+1,1) = weights(x+y-i-j+1,1) + ....
                combination(x,i)*combination(y,j)*(-1.0)^i * cos(angle)^(x-i+j) * sin(angle)^(y+i-j);
        end
    end
    
    for k = 0:x+y
        index = Mgetfilterindex(x+y-k, k, t, basis.numimages) + 1;
        if (sign(index)==1 && weights(x+y-k+1,1)~=0.0)
%            work.data = work.data + weights(x+y-k+1,1) * basis.data(:,:,s+1,index);
            work.data(:,:,1,1) = work.data(:,:,1,1) + weights(x+y-k+1,1) * basis.data(:,:,1,index);
            work.data(:,:,2,1) = work.data(:,:,2,1) + weights(x+y-k+1,1) * basis.data(:,:,2,index);
            work.data(:,:,3,1) = work.data(:,:,3,1) + weights(x+y-k+1,1) * basis.data(:,:,3,index);
        end
    end
end

function [index] = Mgetfilterindex(x, y, t, numimages)

    NUM_TEMPORAL = 3;
    index = 0;
    
%     index = combination(x+y+1, 2) + y;
    for i = 1:x+y
        index = index + i;
    end
    
    index = index + y;
    
    numim = numimages/NUM_TEMPORAL;
    if (index >= numim)
%         disp(['index is overload: ' num2str(index) ':' num2str(x) ':' num2str(y) ':' num2str(t)]);
        index = -64;
    end

    index = index + t * numim;
    if (index >= numimages)
        disp(['index is overload all: ' num2str(index)]);
    end
end