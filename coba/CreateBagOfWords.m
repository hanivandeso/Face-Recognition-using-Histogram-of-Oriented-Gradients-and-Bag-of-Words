%Author: Jacob Gildenblat, 2014.
%Creates a bag of words from a dataset.
%blockSize is the size of the cells in the HoG descriptors.
%patchSize is the size of the patches. Each patch is used for a HoG
%descriptor.
%directories is a cell array containing two directories with the training
%images.
%trainSetPercentage sets how many images are used for training, and how
%many are used for crosss validation.

%%
% function features = CreateBagOfWords(blockSize, patchSize, directories, trainSetPercentage)
function features = CreateBagOfWords(blockSize, patchSize, trainSetPercentage)
       
    max_size = 10000;
    features = zeros(max_size, patchSize * 31);
    
    %% Load image data
    
    load(fullfile('Data', 'member.mat'));
    %%
    index = 1;
    %for i = 1:length(directories)
    for i = 1:size(imageData,2)
%         directory = char(directories(i));
%         imagefiles = dir([directory, '/', '*.jpg']);
        imagefiles = imageData;
        nfiles = length(imagefiles);
        for ii=1:round(nfiles*trainSetPercentage)
%             img = imread([directory ,'/', imagefiles(ii).name]);
            img = imageData{ii};
            if (size(img , 1) < patchSize * 2 || size(img, 2) < patchSize * 2)
                continue;
            end
            hogPatches = ExtractHogPatches(img, patchSize, blockSize);
            features(index : index + size(hogPatches, 1) - 1 , :) = hogPatches;
            index = index + size(hogPatches, 1);     
        end
    end
   features = features(1 : index - 1, :);
   disp('features size is: ')
   size(features')
end
