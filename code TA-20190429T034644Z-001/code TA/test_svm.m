clc;
clear;

%%%%%%%%%%%%%%%%%%%%%% LOAD THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\testSVM\';
list = dir( 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\testSVM\*.jpg');

HOG_test = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    feature_HOG = HOG(im);
    HOG_test = [HOG_test; feature_HOG];
end

% % PAKE LIBRARY HOG
% HOG_test = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     im = imresize(im, [80 100]);
%     feature_HOG = extractHOGFeatures(im,'cellsize',[10 10],'blocksize',[4 4]);
%     HOG_test = [HOG_test; feature_HOG];
% end

% LBP_test = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     im = imresize(im, [80 100]);
%     im = rgb2gray(im);
%     feature_LBP = extractLBPFeatures(im,'cellsize',[40 50]);
%     LBP_test = [LBP_test; feature_LBP];
% end

% % concate dua data training
% [baris kolom] = size(HOG_test);
% test_HOGLBP = [];
% for i = 1: baris
%     test_HOGLBP(i,:) = [HOG_test(i,:) LBP_test(i,:)];
% end

SVM = loadCompactModel('SVM');
[label score] = predict(SVM,HOG_test);