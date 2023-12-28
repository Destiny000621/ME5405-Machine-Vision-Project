%% 1. Display the image
% Step1: Display the original image on screen
original_image = imread("hello_world.jpg");
figure(1);
imshow(original_image);
% imwrite(original_image, 'original_image.jpg');

% Step2: Create an image which is a sub-image of the original image comprising the middle line – HELLO, WORLD.
% 1. Determine the coordinates of the region of interest (ROI).
x_start = 1;
x_end = size(original_image, 2);
y_start = (size(original_image, 1)/3); % Roughly the starting Y-coordinate of the middle third
y_end = 2*(size(original_image, 1)/3); % Roughly the ending Y-coordinate of the middle third

% 2. Extract the ROI as a sub-image
sub_img = original_image(round(y_start):round(y_end), x_start:x_end, :);

% 3. Display the sub-image
figure(2);
imshow(sub_img);

% 4. Save the sub-image
% imwrite(sub_img, 'sub_image.jpg');

%% 2. Threshold and Filter the image
figure;
% Read the image
img = imread('sub_image.jpg');

% Convert the image to grayscale if it's not already
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% Threshold the image to get a binary representation
binary_img0 = img_gray < 128; % Invert the threshold since text is light and background is dark

% Use connected components to label each distinct region
cc = bwconncomp(binary_img0);

% Get area of each component
area = cellfun(@numel, cc.PixelIdxList);

% Set a threshold for the area based on observation or empirical testing
area_threshold = 150; % This value might need adjustment based on the image specifics

% Filter out small connected components
binary_cleaned = binary_img0;
for i = 1:cc.NumObjects
    if area(i) < area_threshold
        binary_cleaned(cc.PixelIdxList{i}) = 0;
    end
end

% Convert the cleaned binary image back to grayscale
cleaned_image = uint8(binary_cleaned * 255);

% Display the cleaned image
imshow(cleaned_image);
title(['Threshold at: ', num2str(128)]);
% imwrite(cleaned_image, 'cleaned_image.jpg')

%% Global Threshold the image and convert it into binary image
figure;
img = imread('sub_image.jpg');
% Convert the image to grayscale if it's not already
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

GT = Global_Thresholding(img_gray);
binary_image1 = img_gray < GT;
% Use connected components to label each distinct region
cc = bwconncomp(binary_image1);

% Get area of each component
area = cellfun(@numel, cc.PixelIdxList);

% Set a threshold for the area based on observation or empirical testing
area_threshold = 80; % This value might need adjustment based on the image specifics

% Filter out small connected components
binary_cleaned = binary_image1;
for i = 1:cc.NumObjects
    if area(i) < area_threshold
        binary_cleaned(cc.PixelIdxList{i}) = 0;
    end
end

% Convert the cleaned binary image back to grayscale
cleaned_image1 = uint8(binary_cleaned * 255);
imshow(cleaned_image1); 
title(['Global Threshold at: ', num2str(GT)]);

% % 保存二值图像
% imwrite(binary_image1, 'Global_Thresholding.jpg');
%% Otsu Threshold
figure;
img = imread('sub_image.jpg');
% Convert the image to grayscale if it's not already
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

Otsu = Otsu_Thresholding(img_gray);
binary_image2 = img_gray < Otsu;
% Use connected components to label each distinct region
cc = bwconncomp(binary_image2);

% Get area of each component
area = cellfun(@numel, cc.PixelIdxList);

% Set a threshold for the area based on observation or empirical testing
area_threshold = 60; % This value might need adjustment based on the image specifics

% Filter out small connected components
binary_cleaned = binary_image2;
for i = 1:cc.NumObjects
    if area(i) < area_threshold
        binary_cleaned(cc.PixelIdxList{i}) = 0;
    end
end

% Convert the cleaned binary image back to grayscale
cleaned_image2 = uint8(binary_cleaned * 255);
imshow(cleaned_image2)
title(['Otsu Threshold at: ', num2str(Otsu)]);

%% 3.Determine a one-pixel thin image of the object
figure;
one_pixel_image1 = one_pixel_image(~binary_img0);
imshow(one_pixel_image1); 
title('One pixel thinned image');

%%  One pixel thin image, using toolbox
figure;
% Determine a one-pixel thin image of the characters.
% 1. Perform skeletonization
skeleton_img = bwmorph(~cleaned_image, 'skel', Inf);

% 2. Display the skeletonized image
imshow(skeleton_img);
title('One pixel thinned image, using toolbox');

% 3. Save the image
% imwrite(skeleton_img, 'skeleton_image.jpg');

%% 4. Determine the outline(s)
figure;
outline_image = outline_image(~binary_img0);
imshow(outline_image)
title('Outlined image');
% imwrite(outline_image, 'outline_image.jpg')

%%  outline image, using toolbox
figure;
edges_canny = edge(~cleaned_image, 'Canny');

% Display the result
imshow(edges_canny);
title('Outline image, using toolbox');

% Save the image
% imwrite(edges_canny, 'edges_canny.jpg');
%% 5. Label the different objects with 4 connectivity
figure;
[out_img1,num1] = twopass_4_connectivity(~binary_img0);                          
img_rgb1 = label2rgb(out_img1, 'jet', [0 0 0], 'shuffle'); 
imshow(img_rgb1);
title(['Two Pass method with 4 connectivity, Label numbers: ',num2str(num1)]);
% imwrite(img_rgb1, 'Label.jpg')

%%  Label the different objects with 8 connectivity
figure;
[out_img2,num2] = twopass_8_connectivity(~binary_img0);                          
img_rgb2 = label2rgb(out_img2, 'jet', [0 0 0], 'shuffle');
imshow(img_rgb2);
title(['Two Pass method with 8 connectivity, Label numbers: ',num2str(num2)]);

%% Label using toolbox
figure;
% Label the connected components
[labeled_img, num_objects] = bwlabel(~cleaned_image);

% Create a color map with a unique color for each label
color_map = label2rgb(labeled_img, 'jet', 'k', 'shuffle'); % 'jet' colormap, black background, random order

% Display the labeled image with unique colors
imshow(color_map);
title(['Label the objects using toolbox, Label numbers: ',num2str(num_objects)]);
% imwrite(color_map, 'label_color.jpg')
