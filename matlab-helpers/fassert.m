function [  ] = fassert( tf )
if ~tf
    error('f-assertion failed.');
end
end

