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
% 70%����������ѵ�� 30%��������������
trainSize = round(0.7*N);
% ѵ��������Լ��ı��
trainNO = dataSet(1:trainSize,1);
testNO = dataSet(trainSize+1:end,1);
% ѵ��������Լ��ı�ǩ
trainLabel = dataSet(1:trainSize,2);
testLabel = dataSet(trainSize+1:end,2);
% ����y=1��y=0�ĸ���
p1 = sum(trainLabel) / trainSize;
p0 = 1 - p1;

%% ʹ��ƽ��ֵ����ѵ��

trainX_MEAN = dataSet(1:trainSize,3:12);
testX_MEAN = dataSet(trainSize+1:end,3:12); 
% ƽ��ֵ�����е������븺��
trainX1_MEAN = trainX_MEAN(trainLabel == 1,:);
trainX0_MEAN = trainX_MEAN(trainLabel == 0,:);
minValue = min(dataSet(:,12));
maxValue = max(dataSet(:,12));
averageValue = mean(dataSet(:,12));



%% ������ֵĴ���������ֵ�Ĵ�С��
% ����ĳ��ֵ����Ϊ1��
count1 = zeros(1,D-22);
count0 = count1;
alpha = [alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10];

% ����y=1��ÿһ������������ֵ�Ĵ���
for ii  = 1 : size(trainX1_MEAN,1)
    for jj = 1:length(alpha)
        if trainX1_MEAN(ii,jj) >= alpha(jj)
            count1(jj) = count1(jj) + 1;
        end
    end
end
% ����y=0��ÿһ������������ֵ�Ĵ���
for ii = 1 : size(trainX0_MEAN,1)
    for jj = 1:length(alpha)
        if trainX0_MEAN(ii,jj) >= alpha(jj)
            count0(jj) = count0(jj) + 1;
        end
    end
end

% ����p(x|y=1)
% 1-p(x=1|y=1)=p(x=0|y=1)
phi1 = count1 / trainSize;
% ����p(x|y=0)
phi0 = count0 / trainSize;
   
%% ����
pred = zeros(size(testLabel));
for ii = 1 : length(testX_MEAN)
    likelyhood1 = p1;
    likelyhood0 = p0;
    
    for jj = 1 : D-22 %��һ��
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

fprintf('��ȷ�ʣ� %f\n',sum(current)/length(testLabel));
fprintf('�����ʣ� %f\n\n',sum(err)/length(testLabel));


