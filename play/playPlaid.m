sf=2
a=2
p=0.2

clear im

for i=1:500
    for j=1:500
        
        im(i,j)=sin(cos(a)*(i*((sf*2*pi)/i)) +sin(a) *(j*((sf*2*pi)/j)) +p)  +sin(cos(a) * ((i*sf*2*pi)/i) - sin(a) * ((j*sf*2*pi)/j) + p);
        % im(i,j,2)=sin(cos(a)*(i*((sf*2*pi)/i)) +sin(a) *(j*((sf*2*pi)/j)) +p)  +sin(cos(a) * ((i*sf*2*pi)/i) - sin(a) * ((j*sf*2*pi)/j) + p);
          %im(i,j,3)=sin(cos(a)*(i*((sf*2*pi)/i)) +sin(a) *(j*((sf*2*pi)/j)) +p)  +sin(cos(a) * ((i*sf*2*pi)/i) - sin(a) * ((j*sf*2*pi)/j) + p);
        
    end
end

imagesc(im)