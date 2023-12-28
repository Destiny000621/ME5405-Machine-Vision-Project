%% Image classification with kNN classifier
% input data
dataset = imageDatastore(fullfile('p_dataset_26'),'IncludeSubfolders',true,'LabelSource','foldernames');

% use 75% of the dataset for training and 25% for testing
[train_set, test_set] = splitEachLabel(dataset,0.75);

%% Features Extraction using HOG
% Using different cell size on HOG 
img = readimage(dataset,11);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);
[hog_16x16, vis16x16] = extractHOGFeatures(img,'CellSize',[16 16]);
[hog_32x32, vis32x32] = extractHOGFeatures(img,'CellSize',[32 32]);

% cell size selected
cell_size = [32 32];
hog_feature_size = length(hog_32x32);

% feature extraction on train dataset
num_images = numel(train_set.Files);
train_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(train_set,i);
    train_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

train_labels = train_set.Labels;

% feature extraction on test dataset
num_images = numel(test_set.Files);
test_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(test_set,i);
    test_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

test_labels = test_set.Labels;

%% train KNN classifier(matrix)
accuracy_n_1 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'euclidean', n, 0, 'inverse');
    accuracy_n_1(end+1) = accuracy;
end

accuracy_n_2 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 0, 'inverse');
    accuracy_n_2(end+1) = accuracy;
end

accuracy_n_3 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'minkowski', n, 0, 'inverse');
    accuracy_n_3(end+1) = accuracy;
end

%% Data Visualization
x = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
accuracy_data = [accuracy_n_1; accuracy_n_2; accuracy_n_3]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 800, 600]); % Position and size: [left, bottom, width, height]

% Create the bar graph
bar(x, accuracy_data, 'grouped');
legend('euclidean', 'cityblock', 'minkowski', 'Location', 'eastoutside'); % Add a legend
xlabel('Number of Neighbors (n)'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Number of Neighbors for kNN Classifier with Different Distance Matrix (Cell Size: 16)'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
min_accuracy = min(accuracy_data(:));
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
text(x(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
%% train KNN classifier(Standardize)
accuracy_n_2_1 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 1, 'inverse');
    accuracy_n_2_1(end+1) = accuracy;
end

%% Data Visualization
x = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
accuracy_data = [accuracy_n_2; accuracy_n_2_1]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 800, 600]); % Position and size: [left, bottom, width, height]

% Create the bar graph
bar(x, accuracy_data, 'grouped');
legend('Standardize: False', 'Standardize: True', 'Location', 'eastoutside'); % Add a legend
xlabel('Number of Neighbors (n)'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Number of Neighbors for kNN Classifier with different Standardization'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
text(x(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');

%% train KNN classifier (DistanceWeight)
accuracy_n_2_e = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 0, 'equal');
    accuracy_n_2_e(end+1) = accuracy;
end

accuracy_n_2_s = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 0, 'squaredinverse');
    accuracy_n_2_s(end+1) = accuracy;
end

%% Data Visualization
x = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
accuracy_data = [accuracy_n_2_e; accuracy_n_2; accuracy_n_2_s]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 800, 600]); % Position and size: [left, bottom, width, height]

% Create the bar graph
bar(x, accuracy_data, 'grouped');
legend('equal', 'inverse', 'squaredinverse', 'Location', 'eastoutside'); % Add a legend
xlabel('Number of Neighbors (n)'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Number of Neighbors for kNN Classifier with Different Distance Weight'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
text(x(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');

%% train KNN classifier (8*8)
accuracy_n_2_8 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 0, 'inverse');
    accuracy_n_2_8(end+1) = accuracy;
end

%% train KNN classifier (32*32)
accuracy_n_1_32 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'euclidean', n, 0, 'inverse');
    accuracy_n_1_32(end+1) = accuracy;
end

accuracy_n_2_32 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'cityblock', n, 0, 'inverse');
    accuracy_n_2_32(end+1) = accuracy;
end

accuracy_n_3_32 = [];
for n = 3:2:30
    [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, 'minkowski', n, 0, 'inverse');
    accuracy_n_3_32(end+1) = accuracy;
end
%% Data Visualization (Cell Size)
x = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
accuracy_data = [accuracy_n_1_32; accuracy_n_2_32; accuracy_n_3_32]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 800, 600]); % Position and size: [left, bottom, width, height]

% Create the bar graph
bar(x, accuracy_data, 'grouped');
legend('euclidean', 'cityblock', 'minkowski', 'Location', 'eastoutside'); % Add a legend
xlabel('Number of Neighbors (n)'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Number of Neighbors for kNN Classifier with Different Distance Matrix (Cell Size:32)'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
min_accuracy = min(accuracy_data(:));
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
text(x(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');

%% Data Visualization
x = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
accuracy_data = [accuracy_n_2_8; accuracy_n_2; accuracy_n_2_32]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 800, 600]); % Position and size: [left, bottom, width, height]

% Create the bar graph
bar(x, accuracy_data, 'grouped');
legend('Cell Size: 8', 'Cell Size: 16', 'Cell Size: 32', 'Location', 'eastoutside'); % Add a legend
xlabel('Number of Neighbors (n)'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Number of Neighbors for kNN Classifier with Different Feature Cell Size'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
min_accuracy = min(accuracy_data(:));
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
text(x(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');