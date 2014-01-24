function [  ] = plotDual( shot,vel,angles )
%Plots dual rep of motion fields

subplot(3,1,1);
imagesc(shot);
title('Shot');

subplot(3,1,2);
imagesc(vel);
title('Vel');

subplot(3,1,3);
imagesc(angles);
title('Angles');

end

