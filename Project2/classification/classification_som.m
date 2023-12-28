%% Image classification with SOM classifier
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

figure(1);
subplot(2,3,1:3); imshow(img);

subplot(2,3,4);
plot(vis8x8);
title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});

subplot(2,3,5);
plot(vis16x16);
title({'CellSize = [16 16]'; ['Length = ' num2str(length(hog_16x16))]});

subplot(2,3,6);
plot(vis32x32);
title({'CellSize = [32 32]'; ['Length = ' num2str(length(hog_32x32))]});

% cell size selected by visual observation
cell_size = [16 16];
hog_feature_size = length(hog_16x16);

% feature extraction on train dataset
num_images = numel(train_set.Files);
training_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(train_set,i);
    training_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

training_labels = train_set.Labels;

% feature extraction on test dataset
num_images = numel(test_set.Files);
test_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(test_set,i);
    test_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

test_labels = test_set.Labels;

%% train SOM classifier
tic
[som_classifier, neuron_labels] = trainSOM(training_features,training_labels,test_features,test_labels);
toc

%% SOM prediction
img = imread('cleaned_image.jpg');

binary_img = img < 128;

% Label the connected components
[labeled_img, num_objects] = bwlabel(binary_img);

% Segment
segmented_images = segment(labeled_img, 60);

figure(2);
num = size(segmented_images,3);
col = round(num/2);
for n = 1:num
    subplot(2,col,n);
    imshow(segmented_images(:,:,n));
end

keep_array = [1 2 3 4 5 7 8 9 10 11];
char_array = ['HELLOWORLD'];
figure(3);
count = 1;
selected_images = true(size(segmented_images,1), size(segmented_images,2), 10);
for n = 1:num
    if (ismember(n, keep_array))
        subplot(2,5,count);
        selected_images(:,:,count) = segmented_images(:,:,n);
        imshow(selected_images(:,:,count));
        title(char_array(count));
        count = count + 1;
    end
end

num = size(selected_images,3);
resized_images = true(128, 128, num);
for n = 1:num
    resized_images(:,:,n) = imresize(selected_images(:,:,n), [128 128]);
end

num = size(resized_images,3);
features = zeros(num,hog_feature_size,'single');
for i = 1:num
    img = resized_images(:,:,i);
    features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

predicted_labels_som = classify_with_som(som_classifier, neuron_labels, features);
figure(4); 
col = round(num/2);
resized_images = true(128, 128, num);
for n = 1:num
    subplot(2,col,n);
    resized_images(:,:,n) = imresize(selected_images(:,:,n), [128 128]);
    imshow(resized_images(:,:,n));
    title(predicted_labels_som(n));
end
sgtitle('SOM Predicted Labels');