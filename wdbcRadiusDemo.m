function wdbcDemo()

clear;clc;close all;
c = rng(1234);

load('datasets/wdbc.data');
[N,D] = size(wdbc);

alpha1 = 0.4;
alpha2 = 1.9;
alpha3 = 4.1;
alpha4 = 35;
alpha5 = 0.014;
alpha6 = 0.0255;
alpha7 = 0;
alpha8 = 0.0118;
alpha9 = 0.05;
alpha10 = 0;
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

%% 使用标准值进行训练
trainX_RADIUS = dataSet(1:trainSize,13:22);
testX_RADIUS = dataSet(trainSize+1:end,13:22);
% 标准值中所有的正例与负例
trainX1_RADIUS = trainX_RADIUS(trainLabel == 1,:);
trainX0_RADIUS = trainX_RADIUS(trainLabel == 0,:);

minValue = min(dataSet(:,22));
maxValue = max(dataSet(:,22));
averageValue = mean(dataSet(:,22));



%% 计算出现的次数？出现值的大小？
% 大于某个值，记为1？
count1 = zeros(1,D-22);
count0 = count1;
alpha = [alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10];

% 计算y=1的每一个特征满足阈值的次数
for ii  = 1 : size(trainX1_RADIUS,1)
    for jj = 1:length(alpha)
        if trainX1_RADIUS(ii,jj) >= alpha(jj)
            count1(jj) = count1(jj) + 1;
        end
    end
end
% 计算y=0的每一个特征满足阈值的次数
for ii = 1 : size(trainX0_RADIUS,1)
    for jj = 1:length(alpha)
        if trainX0_RADIUS(ii,jj) >= alpha(jj)
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
for ii = 1 : length(testX_RADIUS)
    likelyhood1 = p1;
    likelyhood0 = p0;
    
    for jj = 1 : D-22 %第一行
        if testX_RADIUS(ii,jj)>=alpha(jj)
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


