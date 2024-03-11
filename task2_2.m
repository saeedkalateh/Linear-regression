clear;
clc;
%% Import data
filename = 'C:\Users\Saeed\Desktop\Saeed\Assignment2\mtcarsdata-4features.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
filename = 'C:\Users\Navid\Desktop\Saeed\Assignment2\mtcarsdata-4features.csv';
delimiter = ',';
startRow = 2;
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
data = cell2mat(raw);
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp;
%%  Using columns mpg and weight
data_task=data(:,[1 4]);
x=data_task(:,1);
t=data_task(:,2);

x_hat=mean(x);
t_hat=mean(t);
w1=(sum((x-x_hat).*(t-t_hat)))/sum((x-x_hat).^2);
w0=t_hat-w1*x_hat;

figure('name',"One-dimensional with intercept, Motor Trends dataset");
plot(x, t,"bx", x, w1*x+w0, "r-");
xlabel("mpg");ylabel("weight");

clearvars data_task x t x_hat t_hat w1 w0

%% Multi-dimensional problem on the complete MTcars data
% Using all four columns (predict mpg with the other three columns
x=data(:,2:4);
t=data(:,1);

w=pinv(x'*x)*x'*t;
y=x*w;

%% Task3: Task 2.3 with 5% and 95% of data
figure('name',"One-dimensional with intercept Motor DataSet");
for i=1:10
n=round(0.05*length(data));
randomSet = randperm(length(data),length(data));
rand5perOfData=data(randomSet(1:n),:);
rand95perOfData=data(randomSet(n:length(randomSet)),:);

% One-dimensional problem with intercept on the Motor Trends car data
% Using columns mpg and weight
data_task=rand5perOfData(:,[1 4]);
x=data_task(:,1);
t=data_task(:,2);

x_hat=mean(x);
t_hat=mean(t);
w1=(sum((x-x_hat).*(t-t_hat)))/sum((x-x_hat).^2);
w0=t_hat-w1*x_hat;

mse5=sum((t-(w1*x+w0)).^2);

subplot(5,2,i);
plot(data(:,1), data(:,4),"bx");
xlabel("mpg");ylabel("weight");

% Using columns mpg and weight
data_task=rand95perOfData(:,[1 4]);
x=data_task(:,1);
t=data_task(:,2);

% calculating mean square error
mse95=sum((t-(w1*x+w0)).^2);

hold on;
plot(data(:,1), w1*data(:,1)+w0, "g-");
xlabel("mpg");ylabel("weight");
title(["5% mse= "+num2str(mse5)+" | 95% mse= "+num2str(mse95) " "]);
legend("data points","Regression using 5% of data")
errors(i,1)=mse5;
errors(i,2)=mse95;

end

mse_for_one_d=errors;

clearvars data_task x t x_hat t_hat rand5perOfData n 
clearvars w1 w0 errors i mse95 mse5 rand95perOfData w y

%% Task3: Task 2.4 with 5% and 95% of data
for i=1:10
n=round(0.05*length(data));
randomSet = randperm(length(data),length(data));
rand5perOfData=data(randomSet(1:n),:);
rand95perOfData=data(randomSet(n:length(randomSet)),:);

x=rand5perOfData(:,2:4);
t=rand5perOfData(:,1);

w=pinv(x'*x)*x'*t;
y=x*w;

mse5=sqrt(sum((y-t).^2));

x=rand95perOfData(:,2:4);
t=rand95perOfData(:,1);
y=x*w;

mse95=sum((y-t).^2);

errors(i,1)=mse5;
errors(i,2)=mse95;
end
figure;
subplot(2,1,1);
bar(errors(:,1),'g');
legend( "mse for 5% of data");
subplot(2,1,2);
bar(errors(:,2));
legend( "mse for 95% of data");

mse_for_multi_d=errors;

clearvars data_task x t x_hat t_hat rand5perOfData n 
clearvars w1 w0 errors i mse95 mse5 rand95perOfData w y


