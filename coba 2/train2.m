clear;
clc;
close all;

% blockSize = [4,4];
blockSize = 4;
patchSize = 16;
trainsetVal = 1;
% directories = {' mac' , 'win'};
directories = {fullfile('Data','Ade'),...
    fullfile('Data', 'Alvin'),...
    fullfile('Data', 'Ardy'),...
    fullfile('Data', 'Daffa'),...
    fullfile('Data', 'Fadil'),...
    fullfile('Data', 'Hanif'),...
    fullfile('Data', 'Liu'),...
    fullfile('Data', 'Maula'),...
    fullfile('Data', 'Mentari'),...
    fullfile('Data', 'Muadz'),...
    fullfile('Data', 'Nada'),...
    fullfile('Data', 'Redy'),...
    fullfile('Data', 'Rezky'),...
    fullfile('Data', 'Ria'),...
    fullfile('Data', 'Sena'),...
    fullfile('Data', 'Wiranata'),...
    fullfile('Data', 'Yuda')...
    fullfile('Data', 'Yusuf')};
% directories = {dir('Data\**')}
% directories = {fullfile('Data','Ade'), fullfile('Data', 'Alvin')};

disp('Collecting features from dataset.. ')
features = CreateBagOfWords(blockSize, patchSize, directories, trainsetVal);
features = features'; %matlab's kmeans
disp('Features collected, clustering.. ')
% [codebook, assignments] = vl_kmeans(features', 20, 'Initialization', 'plusplus'); %vl_kmeans


tic;
[assignments, codebook] = kmeans(features', 1300 ,'Distance','sqeuclidean','Display','final',...
    'Replicates',15,'Options',statset('UseParallel',1)); %matlab's kmeans
toc
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
    XtrainPartition = Xtrain(cv.training(i),:);
    YtrainPartition = Ytrain(cv.training(i),:);
    testPartition = Xtrain(cv.test(i),:);
    labelTestPartition = Ytrain(cv.test(i),:);
    
%     svmParams = templateSVM('Standardize',true,'KernelFunction','gaussian'); %RBF
    svmParams = templateSVM('Standardize',true,'KernelFunction','linear'); %linear
    svmMdl =fitcecoc(XtrainPartition, YtrainPartition, 'Learners',svmParams,'coding','onevsone');
    %linear dikasus ini lebih baik dari RBF sekalipun diuji di
    %classification learner
    
    predict = svmMdl.predict(testPartition);
    correctPredict = predict == labelTestPartition; %Output Logical Value
    confusionMat{i} = confusionmat(predict, labelTestPartition);
    accuracy(i) = sum(correctPredict) / size(labelTestPartition, 1);
    accuracy(i)
end
% jumlah keseluruhan confusion matrix
sumConfusion = zeros(18,18);
for i = 1:size(confusionMat,2)
    sumConfusion = sumConfusion + confusionMat{i};
end

% rata-rata akurasi
averageAcc = mean(accuracy);
percentAcc = averageAcc * 100;
percentAcc
