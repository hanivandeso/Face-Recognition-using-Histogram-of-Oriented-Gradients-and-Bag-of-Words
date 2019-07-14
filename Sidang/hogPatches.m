function hog_patches = hogPatches(img, frames, patchSize, blockSize)

hog_patches = [];

a = patchSize(1);
b = patchSize(2);

if size(img, 1) <= a || size(img, 2) <= b
% if size(img, 1) <= patchSize || size(img, 2) <= patchSize
    img = imresize(img, [256 256]);
end

for f = frames
    x = round(f(1)); y = round(f(2));
    x = min(max(x, a), size(img, 1) - a);
    y = min(max(y, b), size(img, 2) - b);
%     x = min(max(x, patchSize), size(img, 1) - patchSize);
%     y = min(max(y, patchSize), size(img, 2) - patchSize);
    
    %dari titik tengah x,y membuat patch seukuran patch size
    patch = img( x - a/2 : x + a/2, y - b/2 : y + b/2);
%     patch = img( x - patchSize/2 : x + patchSize/2, y - patchSize/2 : y + patchSize/2);
%     hog = vl_hog(patch, blockSize);
    hog = extractHOGFeatures(patch,'BlockSize',blockSize,'NumBins',24);
    hog = reshape(hog, 1, []); %merangkai ulang array hog 
    hog_patches = [hog_patches ; hog];
end

end