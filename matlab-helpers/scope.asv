function [  ] = scope( x )
%Gives some details about an image

[si sj c]=size(x);

fprintf('\nData is %d by %d by %d.\n',si, sj,c);
fprintf(['Class is ' class(x) '\n']);
if isreal(x)
fprintf('REAL.\n');
else
    fprintf('COMPLEX.\n');
end
mn=min(min(min(x)));
mx=max(max(max(x)));
xmean=mean(mean(mean(x)));
fprintf('Range: %f to %f with mean %f.\n',mn, mx,xmean);

fprintf('\n');

end

