%% Image classification with SVM classifier
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

%% train SVM classifier
boxconstraints = [0.1, 1, 10, 100];
accuracy_g = [];
for bc = boxconstraints
    [svm_classifier, accuracy] = trainSVM(training_features,training_labels,test_features,test_labels, "gaussian", bc, 'auto');
    accuracy_g(end+1) = accuracy;
end

accuracy_l = [];
for bc = boxconstraints
    [svm_classifier, accuracy] = trainSVM(training_features,training_labels,test_features,test_labels, "linear", bc, 'auto');
    accuracy_l(end+1) = accuracy;
end

accuracy_p_2 = [];
for bc = boxconstraints
    [svm_classifier, accuracy] = trainSVM_poly(training_features,training_labels,test_features,test_labels, "polynomial", bc, 'auto', 2);
    accuracy_p_2(end+1) = accuracy;
end

accuracy_p_3 = [];
for bc = boxconstraints
    [svm_classifier, accuracy] = trainSVM_poly(training_features,training_labels,test_features,test_labels, "polynomial", bc, 'auto', 3);
    accuracy_p_3(end+1) = accuracy;
end

accuracy_p_4 = [];
for bc = boxconstraints
    [svm_classifier, accuracy] = trainSVM_poly(training_features,training_labels,test_features,test_labels, "polynomial", bc, 'auto', 4);
    accuracy_p_4(end+1) = accuracy;
end

%% Data Visualization
% Original x values on a log scale
x_log = [0.01, 0.1, 1, 100];
% New x positions for evenly spaced bars
x_positions = 1:length(x_log);
accuracy_data = [accuracy_g; accuracy_l; accuracy_p_2; accuracy_p_3; accuracy_p_4]';

% Create the figure and set its size
fig = figure;
set(fig, 'Position', [100, 100, 900, 500]); % Position and size: [left, bottom, width, height]

% Create the bar graph at the new positions
b = bar(x_positions, accuracy_data, 'grouped');
% Customize the x-axis
set(gca, 'XTick', x_positions); % Set x-ticks to new positions
set(gca, 'XTickLabel', {'0.01', '0.1', '1', '100'}); % Label x-ticks with original log values

legend('gaussian', 'linear', 'polynomial n=2', 'polynomial n=3', 'polynomial n=4', 'Location', 'eastoutside'); % Add a legend
xlabel('Box Constraints'); % Label for x-axis
ylabel('Accuracy'); % Label for y-axis
title('Accuracy vs. Box Constraints for SVM Classifier with Kernel Function (Cell Size: 32)'); % Title of the graph

% Find and display the highest accuracy
max_accuracy = max(accuracy_data(:)); % Find the maximum accuracy
[max_row, max_col] = find(accuracy_data == max_accuracy, 1); % Find the location of the maximum accuracy
%text(x_positions(max_row), max_accuracy, sprintf('%.2f%%', max_accuracy), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
