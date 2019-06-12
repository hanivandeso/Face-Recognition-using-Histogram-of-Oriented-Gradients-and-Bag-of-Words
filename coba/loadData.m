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
%     if (isequal(name{1}, 'Ade'))
%         assign label 0 for Ade
%         label(i,:) = 0;
%     elseif (isequal(name{1}, 'Alvin'))
%         assign label 1 for Alvin
%         label(i,:) = 1;
%     end
    switch name{1}
        case 'Ade'
            label(i,:) = 1;
        case 'Alvin'
            label(i,:) = 2;
        case 'Ardy'
            label(i,:) = 3;
        case 'Daffa'
            label(i,:) = 4;
        case 'Fadil'
            label(i,:) = 5;
        case 'Hanif'
            label(i,:) = 6;
        case 'Liu'
            label(i,:) = 7;
        case 'Maula'
            label(i,:) = 8;
        case 'Mentari'
            label(i,:) = 9;
        case 'Muadz'
            label(i,:) = 10;
        case 'Nada'
            label(i,:) = 11;
        case 'Redy'
            label(i,:) = 12;
        case 'Rezky'
            label(i,:) = 13;
        case 'Ria'
            label(i,:) = 14;
        case 'Sena'
            label(i,:) = 1;
        case 'Wiranata'
            label(i,:) = 16;
        case 'Yuda'
            label(i,:) = 17;
        case 'Yusuf'
            label(i,:) = 18;
    end
    disp([listSubFolder(i).name, ' loaded']);
end

save(fullfile('data','member.mat'), 'imageData', 'label');