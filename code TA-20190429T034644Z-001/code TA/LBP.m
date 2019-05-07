function [ feature ] = LBP( im )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    im = imresize(im, [80 100]);
    im = rgb2gray(im);

    % padding sekeliling image agar semua pixel dapat diproses 
    img = padarray(im,[1 1],'both');
    new_im = zeros(size(im));

    % proses perbandingan dengan setiap tetangga
    [baris kolom] = size(img);
    for i = 2 : baris-1
        for j = 2 : kolom-1
            tmp = [img(i-1,j-1) img(i-1,j) img(i-1,j+1) img(i,j+1) img(i+1,j+1) img(i+1,j) img(i+1,j-1) img(i,j-1)];
            for k = 1 : 8
                if img(i,j) >= tmp(k)
                    arr(k) = 1;
                else 
                    arr(k) = 0;
                end
                str = num2str(arr);
                new_px = bin2dec(str);
            end
            new_im(i-1,j-1) = new_px;
        end
    end

    % buat grid/bagi image jadi beberapa cell, disini saya buat masing2
    % gridnya jadi 10x10 / 40x50
    kx = 40 ; ky = 50 ;
    cell = mat2cell(new_im, repmat(kx,[1 size(new_im,1)/kx]), repmat(ky,[1 size(new_im,2)/ky]));
    arr_hist = {};
    z = 0;

    for p = 1 : 2
        for q = 1 :2
            % hitung histogram masing2 cellnya
            hist = zeros(1,256);
            [baris kolom] = size(cell{p,q});
            for i = 1 : baris
                for j = 1 : kolom
                    hist(1,cell{p,q}(i,j)+1) = hist(1,cell{p,q}(i,j)+1) + 1;
                end
                w = 1;
                for v = 1 : 16
                    hist_n(1,v) = sum(hist(1,w:w+15));
                    w = w+16;
                end
            end
            z = z+1;
            arr_hist{1,z} = hist_n; % jadi array berisi histogram masing2 cell
        end
    end

    % feature akhir berbentuk array didalam cell
    feature = [];
    [x y] = size(arr_hist);
    for i = 1:y
        feature = horzcat(feature,arr_hist{1,i});
    end
    feature = normalize(feature);
    feature_LBP = feature;

end

