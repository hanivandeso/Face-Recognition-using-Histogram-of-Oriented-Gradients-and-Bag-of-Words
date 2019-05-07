% path = 'Dataset 1.2\20_eye\';
% list = dir( 'Dataset 1.2\20_eye\*.jpg');

img = imread('testhog.png');

% PAKE LIBRARY HOG
% [featureVector,hogVisualization] = extractHOGFeatures(img,'cellsize',[10 10],);
% hogt = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     im = imresize(im, [80 100]);
%     feature_HOG = extractHOGFeatures(im,'cellsize',[10 10],'blocksize',[4 4]);
%     hogt = [hogt; feature_HOG];
% end

[hog1,visualization] = extractHOGFeatures(img,'CellSize',[10 10]);

subplot(1,2,1);
imshow(img);
subplot(1,2,2);
plot(visualization);