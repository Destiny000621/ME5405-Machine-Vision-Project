%Segment the image to separate and label the different characters.
% 1. Read the image
img = imread('cleaned_image.jpg');

binary_img = img < 128;

% Label the connected components
[labeled_img, num_objects] = bwlabel(binary_img);

% Create a color map with a unique color for each label
color_map = label2rgb(labeled_img, 'jet', 'k', 'shuffle'); % 'jet' colormap, black background, random order

% Display the labeled image with unique colors
figure(1);
imshow(color_map);
% imwrite(color_map, 'label_color.jpg')

% Segment (can adjust)
segmented_images = segment(labeled_img, 80);

figure(2);
num = size(segmented_images,3);
col = round(num/2);
for n = 1:num
    subplot(2,col,n);
    imshow(segmented_images(:,:,n));
end

%% Keep and display the 10 desired characters (Task 7)
keep_array = [1 2 3 4 5 7 8 9 10 11];
char_array = 'HELLOWORLD';
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

