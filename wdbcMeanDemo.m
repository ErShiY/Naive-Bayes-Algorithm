function wdbcDemo()

clear;clc;close all;
c = rng(1234);

load('datasets/wdbc.data');
[N,D] = size(wdbc);

alpha1 = 15;
alpha2 = 13;
alpha3 = 100;
alpha4 = 650;
alpha5 = 0.0964;
alpha6 = 0.15;
alpha7 = 0.1;
alpha8 = 0.03;
alpha9 = 0.2;
alpha10 = 0.05;
alpha11 = 0.5;

p = randperm(N);
dataSet = wdbc(p,:);
% 70%的数据用作训练 30%的数据用来测试
trainSize = round(0.7*N);
% 训练集与测试集的编号
trainNO = dataSet(1:trainSize,1);
testNO = dataSet(trainSize+1:end,1);
% 训练集与测试集的标签
trainLabel = dataSet(1:trainSize,2);
testLabel = dataSet(trainSize+1:end,2);
% 计算y=1或y=0的概率
p1 = sum(trainLabel) / trainSize;
p0 = 1 - p1;

%% 使用平均值进行训练

trainX_MEAN = dataSet(1:trainSize,3:12);
testX_MEAN = dataSet(trainSize+1:end,3:12); 
% 平均值中所有的正例与负例
trainX1_MEAN = trainX_MEAN(trainLabel == 1,:);
trainX0_MEAN = trainX_MEAN(trainLabel == 0,:);
minValue = min(dataSet(:,12));
maxValue = max(dataSet(:,12));
averageValue = mean(dataSet(:,12));



%% 计算出现的次数？出现值的大小？
% 大于某个值，记为1？
count1 = zeros(1,D-22);
count0 = count1;
alpha = [alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10];

% 计算y=1的每一个特征满足阈值的次数
for ii  = 1 : size(trainX1_MEAN,1)
    for jj = 1:length(alpha)
        if trainX1_MEAN(ii,jj) >= alpha(jj)
            count1(jj) = count1(jj) + 1;
        end
    end
end
% 计算y=0的每一个特征满足阈值的次数
for ii = 1 : size(trainX0_MEAN,1)
    for jj = 1:length(alpha)
        if trainX0_MEAN(ii,jj) >= alpha(jj)
            count0(jj) = count0(jj) + 1;
        end
    end
end

% 计算p(x|y=1)
% 1-p(x=1|y=1)=p(x=0|y=1)
phi1 = count1 / trainSize;
% 计算p(x|y=0)
phi0 = count0 / trainSize;
   
%% 测试
pred = zeros(size(testLabel));
for ii = 1 : length(testX_MEAN)
    likelyhood1 = p1;
    likelyhood0 = p0;
    
    for jj = 1 : D-22 %第一行
        if testX_MEAN(ii,jj)>=alpha(jj)
            likelyhood1 = likelyhood1 * phi1(jj);
            likelyhood0 = likelyhood0 * phi0(jj);
        else
            likelyhood1 = likelyhood1 * (1 - phi1(jj));
            likelyhood0 = likelyhood0 * (1 - phi0(jj));
        end
    end
    pred(ii) = likelyhood1 / (likelyhood0 + likelyhood1);
end
        
p = pred >= alpha11;
err = p~= testLabel;
current = p==testLabel;

fprintf('正确率： %f\n',sum(current)/length(testLabel));
fprintf('错误率： %f\n\n',sum(err)/length(testLabel));


