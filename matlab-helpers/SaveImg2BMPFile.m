% Try File IO operation inside Parfor loop
function SaveImg2BMPFile(FilePathName, Img)
imwrite(Img, FilePathName, 'bmp');
end