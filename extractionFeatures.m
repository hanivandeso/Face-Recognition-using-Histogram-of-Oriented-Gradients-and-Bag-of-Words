clear;
clc;
close all;

%% Load image data
addpath('lib');
load(fullfile('Data', 'member.mat'));

%% Ambil ciri HOG dengan lib Matlab
for i = 1:size(imageData,2)
    grayImage = rgb2gray(imageData{i});
    resizedGrayscale = imresize(grayImage,[80,88]);
    hogFeatures{i,:} = extractHOGFeatures(resizedGrayscale, 'CellSize', [4,4], 'BlockSize' , [8,8]);
    disp(['HOG features from image - ', num2str(i) ,' successfully extracted']);
end
features = cell2mat(hogFeatures);

%% HOG to BOW
% for l = 1:size
% bag = bagOfFeatures(features)

%% Save model
save('extracted_features.mat', 'features', 'label');