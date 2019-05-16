clear;
clc;
close all;

% original size image
listSubFolder = dir('Data\Cropped\**\*.png');
% cropped size image
% listSubFolder = dir('data\cropped\**\*.JPG');
% mixed size image
% listSubFolder = dir('data\mixed\**\*.JPG');

for i = 1:size(listSubFolder,1)
    imageData{i} = imread(fullfile(listSubFolder(i).folder, listSubFolder(i).name));
    name = strsplit(listSubFolder(i).name, '_');
    if (isequal(name{1}, 'Ade'))
        % assign label 0 for Ade
        label(i,:) = 0;
    elseif (isequal(name{1}, 'Alvin'))
        % assign label 1 for Alvin
        label(i,:) = 1;
    end
    disp([listSubFolder(i).name, ' loaded']);
end

save(fullfile('data','member.mat'), 'imageData', 'label');