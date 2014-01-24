%Gets the refs out and does another PCA on them

%Depends on prev having been run first

for i=1:n
    tc=configs{i};
    s=[rightPath(tc,tc.dirPCAModel) 'all\morphMean.bmp'];
    t=[rightPath(c,c.dirSourceBitmaps) 'means\mean' num2str(i) '.bmp'];
    checkDir([rightPath(c,c.dirSourceBitmaps) 'means\']);
    movefile(s,t);
end
     