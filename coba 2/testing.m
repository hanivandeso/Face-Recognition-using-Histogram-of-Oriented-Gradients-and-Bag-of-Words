

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