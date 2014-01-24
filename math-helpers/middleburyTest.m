function [ x,y ] = middleburyTest(  )
%Makes a motion sphere

[x y]=meshgrid(-50:50,50:-1:-50);



for i=1:101
    for j=1:101
        %vel(i,j)=sqrt( (i-50)^2 + (j-50)^2); %Not precise as 50 isn't the centre
        vel(i,j)=10;
        angle(i,j)=atan2(y(i,j),x(i,j))/(pi/180);
    end
end

angle=rot90(angle,3);
vel=rot90(vel,3);
[x y]=out2vecs(vel,angle);

end

