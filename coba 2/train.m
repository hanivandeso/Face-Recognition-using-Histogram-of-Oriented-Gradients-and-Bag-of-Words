clear;
clc;
close all;

% blockSize = [8,8];
blockSize = 4;
patchSize = 16;
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
features = CreateBagOfWords(blockSize, patchSize, directories, 0.8);

disp('Features collected, clustering.. ')
[codebook, assignments] = vl_kmeans(features', 17, 'Initialization', 'plusplus');
% [codebook, assignments] = kmeans(features', 17);

disp('Comparing dataset to codebook.. ')
[Xtrain Ytrain] = CalcHistograms(codebook', blockSize, patchSize, directories, 1, 0.8);

% Save model
extracted_feature = [Xtrain' Ytrain'];
% save('extracted_features.mat', 'extracted_feature');

% xNew = X(:,1:40);
% yNew = Y(:,1:40);
disp('Training SVM classifier.. ')
% [W B] = vl_svmtrain(X, Y, 0.02);

% t = templateSVM('Standardize',true,'KernelFunction','gaussian');
% model_training_svm = fitcecoc(Xtrain', Ytrain','Learners',t);
model_training_svm = fitcecoc(Xtrain', Ytrain');

disp('Success rate on train set: ')
% sum(sign(W' * X + B) == Y) / length(Y)

% [CROSS_VALID_SET CROSS_VALID_LABELS] = CalcHistograms(codebook', blockSize, patchSize, directories, 0, 0);
% disp('Success rate on cross validation set: ')
% sum(sign(W' * CROSS_VALID_SET + B) == CROSS_VALID_LABELS) / length(CROSS_VALID_LABELS)

[Xtest Ytest]=  CalcHistograms(codebook', blockSize, patchSize, directories, 0, 0.8);
model = load('modelSvm.mat');
hasilTestingSVM = predict(model_training_svm, Xtest');

jumlahBenar = 0;
for i=1 : length(hasilTestingSVM)
    if(Ytest(i) == hasilTestingSVM(i))
        jumlahBenar = jumlahBenar+1;
    end
end

% disp('Jumlah Benar :');
jumlahBenar

akurasi = jumlahBenar/length(hasilTestingSVM)