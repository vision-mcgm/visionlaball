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