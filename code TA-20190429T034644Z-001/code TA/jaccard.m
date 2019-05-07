function [ jaccard ] = jaccard(img1,img2)
%JACCARD Summary of this function goes here
%   Detailed explanation goes here
if size(img1) ~= size(img2)
    error('Ukuran gambar tidak sama');
else
    [ tinggi, lebar ] = size(img1);
    
    f11 = 0;
    f10 = 0;
    f01 = 0;
    f00 = 0;
    
    for i=1:lebar
        for j=1:tinggi
            
            if img1(i,j) == 0 && img2(i,j) ==0
                f00 = f00+1;
            elseif img1(i,j)==0 && img2(i,j) ==0
                f10 = f10+1;
            elseif img1(i,j)==0 && img2(i,j) ==0
                f01 = f01 + 1;
            elseif img1(i,j)==1 && img2(i,j) == 1
                f11= f11+1;
            end
        end
    end
    
    a = f11; b = f01; c = f10; d = f00;
    jaccard = a/(a+b+c+d);
end
end

