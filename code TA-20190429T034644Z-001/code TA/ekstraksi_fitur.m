clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%% LOAD THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\kepala\';
list = dir( 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\kepala\*.jpg');

HOG_Positif = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    feature_HOG = HOG(im);
    HOG_Positif = [HOG_Positif; feature_HOG];
end

 
% [featureVector,hogVisualization] = extractHOGFeatures(img,'cellsize',[10 10],'blocksize',[4 4]);
% HOG_Positif = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     im = imresize(im, [80 100]);
%     feature_HOG = extractHOGFeatures(im,'cellsize',[10 10],'blocksize',[4 4]);
%     HOG_Positif = [HOG_Positif; feature_HOG];
% end


% LBP_positif = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     feature_LBP = LBP(im);
%     LBP_positif = [LBP_positif; feature_LBP];
% end

% PAKE LIBRARY
LBP_positif = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    im = imresize(im, [80 100]);
    im = rgb2gray(im);
    feature_LBP = extractLBPFeatures(im,'cellsize',[40 50]);
    LBP_positif = [LBP_positif; feature_LBP];
end


% concate dua data training
[baris kolom] = size(HOG_Positif);
positif_HOGLBP = [];
for i = 1: baris
    positif_HOGLBP(i,:) = [HOG_Positif(i,:) LBP_positif(i,:)];
end

[row col] = size(positif_HOGLBP);
% kasih nama kelas kepala di ujung kolom
for i = 1: row
    positif_HOGLBP(i,col+1) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%% LOAD THE IMAGES NEGATIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\Negatif\';
list = dir( 'D:\1. Data\2. Telkom University\1. Kuliah\Semester 8\Tugas Akhir\Code\tugasAkhir\Negatif\*.jpg');

HOG_negatif = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    feature_HOG = HOG(im);
    HOG_negatif = [HOG_negatif; feature_HOG];
end

% % PAKE LIBRARY HOG
% HOG_negatif = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     im = imresize(im, [80 100]);
%     feature_HOG = extractHOGFeatures(im,'cellsize',[10 10],'blocksize',[4 4]);
%     HOG_negatif = [HOG_negatif; feature_HOG];
% end

% LBP_negatif = [];
% for k = 1:numel(list)
%     im = imread([path list(k).name]);
%     feature_LBP = LBP(im);
%     LBP_negatif = [LBP_negatif; feature_LBP];
% end

% PAKE LIBRARY
LBP_negatif = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    im = imresize(im, [80 100]);
    im = rgb2gray(im);
    feature_LBP = extractLBPFeatures(im,'cellsize',[40 50]);
    LBP_negatif = [LBP_negatif; feature_LBP];
end


% concate dua data training
[baris kolom] = size(HOG_negatif);
negatif_HOGLBP = [];
for i = 1: baris
    negatif_HOGLBP(i,:) = [HOG_negatif(i,:) LBP_negatif(i,:)];
end

% kasih nama kelas kepala di ujung kolom
[row col] = size(negatif_HOGLBP);
for i = 1: row
    negatif_HOGLBP(i,col+1) = 0;
end

ex_fitur = [positif_HOGLBP;negatif_HOGLBP];

% Training SVM
[row col] = size(ex_fitur);
SVM = fitcsvm( ex_fitur(:,1:col-1),ex_fitur(:,col) );

saveCompactModel(SVM,'SVM');