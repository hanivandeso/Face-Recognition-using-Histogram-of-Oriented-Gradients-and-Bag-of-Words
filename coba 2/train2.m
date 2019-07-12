clear;
clc;
close all;
%%
blockSize = [2 2];
patchSize = [40 44];
% patchSize = 16;
trainsetVal = 1;

directories = loadDir();
%%
disp('Collecting features from dataset.. ')
features = CreateBagOfWords(blockSize, patchSize, directories, trainsetVal);
features = features'; %matlab's kmeans
disp('Features collected, clustering.. ')
% [codebook, assignments] = vl_kmeans(features', 20, 'Initialization', 'plusplus'); %vl_kmeans
%%
[assignments, codebook] = kmeans(features', 80 ,'Distance','sqeuclidean','Display','final',...
    'Replicates',5); %matlab's kmeans
%Distance = euclidian (default)
%Replicate = mencari distance terbaik disetiap iterasinya

disp('Comparing dataset to codebook.. ')
% [Xtrain Ytrain] = CalcHistograms(codebook', blockSize, patchSize, directories, 1, trainsetVal); %vl_kmeans
[Xtrain Ytrain] = CalcHistograms(codebook, blockSize, patchSize, directories, 1, trainsetVal); %matlab's kmeans

% Save model
extracted_feature = [Xtrain Ytrain];
% save('extracted_features.mat', 'extracted_feature');

% xNew = X(:,1:40);
% yNew = Y(:,1:40);
disp('Training SVM classifier.. ')

%% Fit into svm classifier
% membuat partisi kfold cross validation
cv = cvpartition(Ytrain, 'KFold', 10);

% train semua data untuk setiap partisi
for i = 1:cv.NumTestSets
    i
    XtrainPartition = Xtrain(cv.training(i),:);
    YtrainPartition = Ytrain(cv.training(i),:);
    testPartition = Xtrain(cv.test(i),:);
    labelTestPartition = Ytrain(cv.test(i),:);
    
    svmParamsR = templateSVM('Standardize',true,'KernelFunction','gaussian'); %RBF
    svmParamsP = templateSVM('Standardize',true,'KernelFunction','polynomial'); % polynomial
    svmParamsL = templateSVM('Standardize',true,'KernelFunction','linear'); %linear
    svmMdlR =fitcecoc(XtrainPartition, YtrainPartition, 'Learners',svmParamsR,'coding','onevsall');
    svmMdlP =fitcecoc(XtrainPartition, YtrainPartition, 'Learners',svmParamsP,'coding','onevsall');
    svmMdlL =fitcecoc(XtrainPartition, YtrainPartition, 'Learners',svmParamsL,'coding','onevsall');
    
    predictR = svmMdlR.predict(testPartition);
    correctPredictR = predictR == labelTestPartition; %Output Logical Value
    accuracyR(i) = sum(correctPredictR) / size(labelTestPartition, 1);
    accuracyR(i);
    
    predictP = svmMdlP.predict(testPartition);
    correctPredictP = predictP == labelTestPartition; %Output Logical Value
    accuracyP(i) = sum(correctPredictP) / size(labelTestPartition, 1);
    accuracyP(i);
%     
    predictL = svmMdlL.predict(testPartition);
    correctPredictL = predictL == labelTestPartition; %Output Logical Value
    accuracyL(i) = sum(correctPredictL) / size(labelTestPartition, 1);
    accuracyL(i);
%     
end

% 0-rata-rata akurasi
averageAccR = mean(accuracyR);
percentAccR = averageAccR * 100;
percentAccR

averageAccP = mean(accuracyP);
percentAccP = averageAccP * 100;
percentAccP

averageAccL = mean(accuracyL);
percentAccL = averageAccL * 100;
percentAccL