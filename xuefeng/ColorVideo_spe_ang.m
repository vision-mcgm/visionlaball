% This is color model_a_v1 matlab version 
clear

nImages=50;

%% Intialize parameters
orders = [5; 2; 2; 2];
angles = 24;
filterthreshold = 0.00000000;
divisionthreshold = 0.00000000;


[d_ltm0, d_ltm1, d_ltm2, SFILT, weights] = ColorMGenfilters(orders);
% quotientfilter = ones(5)/25;

%imdirname = '/Users/alan/Documents/MATLAB/McGMFunc/img/';
% imdirname = 'C:\Documents and Settings\Andy\Desktop\Mat_MCGM\colorgrating\';
% imdirname = 'C:\Documents and Settings\Vision Admin\Desktop\Xiao\MCGM\test_data\monkey_01\';
% imdirname = 'C:\Documents and Settings\Vision Admin.LAPTOP20.000\My Documents\MATLAB\Mcgm-mat\colorgrating\';
% imdirname = 'C:\Documents and Settings\Vision Admin.LAPTOP20.000\My Documents\MATLAB\';
imdirname = 'testImages/';



%% Caculate velocity
ini = false;
% tic
for frame = 1:nImages
    frame
    T0 = ColorMFtfilter(frame, imdirname, d_ltm0);
    T1 = ColorMFtfilter(frame, imdirname, d_ltm1);
    T2 = ColorMFtfilter(frame, imdirname, d_ltm2);

    T0n = T0.data(floor(SFILT.rows/2):T0.rows-ceil(SFILT.rows/2), floor(SFILT.rows/2):T0.cols-ceil(SFILT.rows/2), 1, 1);
    
    basis = ColorMGenbasis(SFILT, T0, T1, T2);
    
    N0 = zeros(basis.rows, basis.cols);
    N1 = zeros(basis.rows, basis.cols);
    N2 = zeros(basis.rows, basis.cols);
    N3 = zeros(basis.rows, basis.cols);
    D0 = zeros(basis.rows, basis.cols);
    D1 = zeros(basis.rows, basis.cols);
    D2 = zeros(basis.rows, basis.cols);
    D3 = zeros(basis.rows, basis.cols);
    A0 = zeros(basis.rows, basis.cols);
    A1 = zeros(basis.rows, basis.cols);
    A2 = zeros(basis.rows, basis.cols);
    A3 = zeros(basis.rows, basis.cols);
    
    for a=0:(angles/2)-1
        angle = 2*a*3.141592654/angles;
        [M0, M1, M2, M3] = ColorMgather(basis, angle, orders, weights,....
            filterthreshold, divisionthreshold);
        
%         M0 = conv2(M0, quotientfilter, 'same');
%         M1 = conv2(M1, quotientfilter, 'same');
%         M2 = conv2(M2, quotientfilter, 'same');
%         M3 = conv2(M3, quotientfilter, 'same');
        
        N0 = N0 + M3*cos(angle);
        N1 = N1 + M1*cos(angle);
        N2 = N2 + M3*sin(angle);
        N3 = N3 + M1*sin(angle);
        D0 = D0 + M0.*M1;
        D1 = D1 + M1.*M2;
        D2 = D2 + M3.*M0;
        D3 = D3 + M3.*M2;
        temp_a = abs(M0).*M1;
        temp_b = abs(M2).*M3;
        A0 = A0 + temp_a*cos(angle);
        A1 = A1 + temp_b*sin(angle);
        A2 = A2 + temp_a*sin(angle);
        A3 = A3 + temp_b*cos(angle);
    end    
    top = N0.*N3 - N1.*N2;
    bottom = D0.*D3 - D1.*D2;
    speed0 = sqrt(abs(Mdefdiv(top, bottom, 1)));
    speed1 = Manglecalc(A0, A1, A2, A3);
    Bimg = [T0n speed0 speed1];
    newimg = uint8(round(outputimage(Bimg, 16)));
    [nr, nc] = size(newimg);
    col = nc/3;
    if ini == false
        img = uint8(zeros(nr, col, 3));
        ini = true;
    end
    for i=1:3
        img(:,:,i) = newimg(:,1+col*(i-1):col*i);
    end
    figure; imshow(img, 'border', 'tight');
    %imwrite(img, 'test.jpg');
    
    if frame==1
        [h w c]=size(img);
        imStack=uint8(zeros(h,w,c,nImages));
    end
    imStack(:,:,:,frame)=img;
end
%     toc