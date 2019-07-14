
clear;
clc;
close all;
%%
blockSize = [2 2];
patchSize = [40 44];
% patchSize = 16;
trainsetVal = 1;

directories = loadTest();
svmModel = loadCompactModel('trained')
%%
disp('Collecting features from dataset.. ')
features = CreateBagOfWords(blockSize, patchSize, directories);
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
[Xtrain Ytrain] = CalcHistograms(codebook, blockSize, patchSize, directories); %matlab's kmeans

% Save model
extracted_feature = [Xtrain Ytrain];
% save('extracted_features.mat', 'extracted_feature');

% xNew = X(:,1:40);
% yNew = Y(:,1:40);
disp('Training SVM classifier.. ')
%%
tpn = sum(diag(sumConfusion));
tp = diag(sumConfusion)';
for i = 1 : size(sumConfusion,1)
    tn(i) = tpn - tp(i);
    fn(i) = sum(sumConfusion(i,:)) - sumConfusion(i,i);
    fp(i) = sum(sumConfusion(:,i)) - sumConfusion(i,i);
end

for i = 1 : size(sumConfusion,1)
    acc(i) = ((tp(i) + tn(i)) / (tp(i) + fp(i) +fn(i) +tn(i)))*100;
    prec(i) = (tp(i)/(tp(i)+fp(i)))*100; %precission, relevansi klasifikasi positif
    sen(i) = (tp(i) / (tp(i) + fn(i))) * 100; %sensitivity/recall, dapat mendeteksi class positif
    spec(i) = (tn(i) / fp(i) + tn(i)) * 100; %specificity, seberapa baik menghindari false alarm?
    fscor(i) = (sen(i) * prec(i) * 2)/(sen(i) + prec(i)); %f1score
end
% disp('Accuracy(%), Precision(%) Sensitivity(%) Specivicity(%) F1Score(%) ');
all = [acc' prec' sen' spec' fscor'];

disp('Overall acc (%)');
acc = tpn/sum(sum(sumConfusion)) * 100