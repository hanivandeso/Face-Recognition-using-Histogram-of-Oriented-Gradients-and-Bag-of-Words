%Author: Jacob Gildenblat, 2014.
%Creates a bag of words from a dataset.
%blockSize is the size of the cells in the HoG descriptors.
%patchSize is the size of the patches. Each patch is used for a HoG
%descriptor.
%directories is a cell array containing two directories with the training
%images.
%trainSetPercentage sets how many images are used for training, and how
%many are used for crosss validation.
function features = CreateBagOfWords(blockSize, patchSize, directories, trainSetPercentage)
       
    % Maximum size dari apa? dan untuk apa?
    max_size = 10000;
    
    % mengalokasikan memori dengan membuat variable
    features = zeros(max_size, patchSize * 31);
    
    index = 1;
    % Perulangan sebanyak direktori
    for i = 1:length(directories)
        directory = char(directories(i));
        imagefiles = dir([directory, '/', '*.png']);      
        nfiles = length(imagefiles);
        
        
        for ii=1:round(nfiles*trainSetPercentage)
            img = imread([directory ,'/', imagefiles(ii).name]);
%             imgr = imresize(img, [80,88]);
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
