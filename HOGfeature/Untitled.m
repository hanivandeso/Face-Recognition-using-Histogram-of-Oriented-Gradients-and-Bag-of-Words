path = 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\kepala\';
list = dir( 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\kepala\*.jpg');


% [featureVector,hogVisualization] = extractHOGFeatures(img,'cellsize',[10 10],'blocksize',[4 4]);
HOG_Positif = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    im = imresize(im, [80 100]);
    feature_HOG = extractHOGFeatures(im,'cellsize',[10 10],'blocksize',[4 4]);
    HOG_Positif = [HOG_Positif; feature_HOG];
end