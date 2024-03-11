clear
clc
%% Import data from text file.
filename = 'C:\Users\Saeed\Desktop\Saeed\Assignment2\turkish-se-SP500vsMSCI.csv';
delimiter = ',';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
data = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;
%% Task 2 part 1
% One-dimensional problem without intercept 
% on the Turkish stock exchange data
x=data(:,1);
t=data(:,2);
w=(t'*x)/sum(x.^2);
% on the whole data
figure('name',"One dimensional, No intercept, Turkish dataset");
subplot(3,1,1);
plot(x, w*x, 'r-', x, t, 'bx');
title("Whole data");
% on a random subsets
n=round(0.1*length(data));
randomSubset = randperm(length(data),n);
subplot(3,1,2);
for i=1:length(randomSubset)
    X(i,:)=data(randomSubset(i),:);
end
plot(X(:,1), w*X(:,1), 'r-', X(:,1), X(:,2), 'bx');
hold on;  
title("Random 10% of data");
clearvars X n i randomSubset
% 5% from beginning and 5% from  the end of data
x1=data(1:round(0.05*length(data)),:);
x2=data(length(data)-round(0.05*length(data)):length(data),:);
X=vertcat(x1,x2);

subplot(3,1,3);
plot(X(:,1),X(:,2),'bx',X(:,1),w*X(:,1),'r-')
title("5% from top & 5% from bottom of data");
clearvars x1 x2 x X w t
%% Task 3: Using only 5% of the data
% Compute the objective on the training data
% Compute the objective of the same models on the remaining 95% of the data.
% Repeat for different training-test random splits, for instance 10 times.
for i=1:10
n=round(0.05*length(data));
randomSubset = randperm(length(data),length(data));
data_task=data(randomSubset(1:n),:);
x=data_task(:,1);
t=data_task(:,2);
w=(t'*x)/sum(x.^2);
y=x*w;
mse5=sum((y-t).^2);

data_task=data(randomSubset(n:length(randomSubset)),:);
x=data_task(:,1);
t=data_task(:,2);
y=x*w;
mse95=sum((y-t).^2);

errors(i,1)=mse5;
errors(i,2)=mse95;

end

clearvars data_task y w x i mse5 mse95 n t randomSubset

figure("Name","Mean Square error for 10 random subset of data");
subplot(2,1,1);
bar(errors(:,1),'g');
legend( "Mean Square Error for 5% of data");
subplot(2,1,2);
bar(errors(:,2));
legend( "Mean Square Error for 95% of data");

