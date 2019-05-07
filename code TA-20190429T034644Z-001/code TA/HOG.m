function [ feature_HOG ] = HOG(im)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    a = imresize(im, [80 100]);
    a = rgb2gray(a);
    % figure;   
    % imshow(a);

    %kalkulasi gradients vertikal dan horizontal
    [X_gradient,Y_gradient] = imgradientxy(a,'sobel');
    hx = [-1,0,1];
    hy = hx.';
    grad_x = imfilter(double(a),hx);
    grad_y = imfilter(double(a),hy);


    % % Hitung Magnitude Gradient dan Direction (Orientation) ##pakai lib
    [magnitude,sudut] = imgradient(grad_x,grad_y);
    % merepresentasikan nilai minus dengan menambahkan 180 , agar nilai
    % orientasi menjadi unsigned
    for i = 1:80
        for j =1:100 
            if sudut(i,j) < 0 
                sudut(i,j) = sudut(i,j) + 180;
            end
        end
    end
    % figure;
    % imshowpair(magnitude,sudut,'montage');
    % % % % sudut = atan2(grad_y, grad_x); %// Signed
    % % % sudut(sudut < 0) = 2*pi + sudut(sudut < 0); %// Unsigned
    % % % % angel = atan2d(grad_y, grad_x); %// Signed
    % % % sudut(sudut < 0) = 360 + sudut(sudut < 0); %// Unsigned


    % %bagi gambar kedalam beberapa cell, disini saya gunakan 10x10
    % pecah gradient magnitude menjadi 10x10 cell
    % [nx,ny] = size(magnitude);
    kx = 10 ; ky = 10 ;
    cell_mag = mat2cell(magnitude, repmat(kx,[1 size(magnitude,1)/kx]), repmat(ky,[1 size(magnitude,2)/ky]));
    % pecah gradient directional menjadi 10x10 cell
    % [nx,ny] = size(sudut);
    kx = 10 ; ky = 10 ;
    cell_dir = mat2cell(sudut, repmat(kx,[1 size(sudut,1)/kx]), repmat(ky,[1 size(sudut,2)/ky]));

    % Buat inisialisasi histogram kosong tiap cell
    for i = 1 :8
        for k = 1:10
            for j = 1:9
                histogram{i,k}(j,1) = 0;
            end
        end
    end

    % perulangan histogram tiap cell
    for baris0 = 1:8
        for kolom0 = 1:10
            for baris = 1:10
                for kolom = 1:10
                    if cell_dir{baris0,kolom0}(baris,kolom) >= 0 && cell_dir{baris0,kolom0}(baris,kolom) <= 20
                        histogram{baris0,kolom0}(1,1) = histogram{baris0,kolom0}(1,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-0)/20);
                        histogram{baris0,kolom0}(2,1) = histogram{baris0,kolom0}(2,1) + cell_mag{baris0,kolom0}(baris,kolom)*((20-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 20 && cell_dir{baris0,kolom0}(baris,kolom) <= 40
                        histogram{baris0,kolom0}(2,1) = histogram{baris0,kolom0}(2,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-20)/20);
                        histogram{baris0,kolom0}(3,1) = histogram{baris0,kolom0}(3,1) + cell_mag{baris0,kolom0}(baris,kolom)*((40-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 40 && cell_dir{baris0,kolom0}(baris,kolom) <= 60
                        histogram{baris0,kolom0}(3,1) = histogram{baris0,kolom0}(3,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-40)/20);
                        histogram{baris0,kolom0}(4,1) = histogram{baris0,kolom0}(4,1) + cell_mag{baris0,kolom0}(baris,kolom)*((60-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 60 && cell_dir{baris0,kolom0}(baris,kolom) <= 80
                        histogram{baris0,kolom0}(4,1) = histogram{baris0,kolom0}(4,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-60)/20);
                        histogram{baris0,kolom0}(5,1) = histogram{baris0,kolom0}(5,1) + cell_mag{baris0,kolom0}(baris,kolom)*((80-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 80 && cell_dir{baris0,kolom0}(baris,kolom) <= 100
                        histogram{baris0,kolom0}(5,1) = histogram{baris0,kolom0}(5,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-80)/20);
                        histogram{baris0,kolom0}(6,1) = histogram{baris0,kolom0}(6,1) + cell_mag{baris0,kolom0}(baris,kolom)*((100-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 100 && cell_dir{baris0,kolom0}(baris,kolom) <= 120
                        histogram{baris0,kolom0}(6,1) = histogram{baris0,kolom0}(6,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-100)/20);
                        histogram{baris0,kolom0}(7,1) = histogram{baris0,kolom0}(7,1) + cell_mag{baris0,kolom0}(baris,kolom)*((120-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 120 && cell_dir{baris0,kolom0}(baris,kolom) <= 140
                        histogram{baris0,kolom0}(7,1) = histogram{baris0,kolom0}(7,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-120)/20);
                        histogram{baris0,kolom0}(8,1) = histogram{baris0,kolom0}(8,1) + cell_mag{baris0,kolom0}(baris,kolom)*((140-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 140 && cell_dir{baris0,kolom0}(baris,kolom) <= 160
                        histogram{baris0,kolom0}(8,1) = histogram{baris0,kolom0}(8,1) + cell_mag{baris0,kolom0}(baris,kolom)*((cell_dir{baris0,kolom0}(baris,kolom)-140)/20);
                        histogram{baris0,kolom0}(9,1) = histogram{baris0,kolom0}(9,1) + cell_mag{baris0,kolom0}(baris,kolom)*((160-cell_dir{baris0,kolom0}(baris,kolom))/20);
                    elseif cell_dir{baris0,kolom0}(baris,kolom) > 160 
                        histogram{baris0,kolom0}(1,1) = histogram{baris0,kolom0}(1,1) + cell_mag{baris0,kolom0}(baris,kolom)/4;
                        histogram{baris0,kolom0}(9,1) = histogram{baris0,kolom0}(9,1) + cell_mag{baris0,kolom0}(baris,kolom)*3/4;
                    end
                end
            end
        end
    end


    % Normalisasi setiap histogram yang diperoleh dari tiap cell yg disatukan
    % menjadi 1 block, tiap blok terdiri dari 4x4 cell
    t = 0;
    for i = 1 : 7
        for j = 1: 9
            t = t+1;
            temp(1,:) = [histogram{i,j};histogram{i,j+1};histogram{i+1,j};histogram{i+1,j+1}];
            theta = norm(temp(1,:));
            for k = 1:36 
                normalisasi{1,t}(1,k) = temp(1,k)/theta;
            end
        end
    end

    % feature akhir berbentuk array didalam cell
    feature = [];
    [x y] = size(normalisasi);
    for i = 1:y
        feature = horzcat(feature,normalisasi{1,i});
    end
    
    feature_HOG = feature;

end

