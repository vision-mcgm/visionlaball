function [ s ] = checkSlash( s )
%Checks for trailing slash

if not(strcmp(s(end),'\'))
    s=[s '\'];
end

end

