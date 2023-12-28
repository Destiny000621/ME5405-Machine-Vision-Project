% Function for image segmentation.
function [segmented_images] = segment(labelled_image, segment_size)

% find all unique non zero nodes
unique_val = unique(labelled_image(labelled_image > 0));
segmented_images = true(segment_size, segment_size, length(unique_val));

for i = 1:length(unique_val)
    % get pixels of each labelled object
    [r, c] = find(labelled_image == i);
    rc = [r c];

    % find the min and max coordinates
    h_min = min(rc(:, 1));
    h_max = max(rc(:, 1));
    w_min = min(rc(:, 2));
    w_max = max(rc(:, 2));

    % create segmented binary image
    image = true(segment_size, segment_size);
    
    % calculate offset
    offset_h = round((segment_size - (h_max - h_min)) / 2);
    offset_w = round((segment_size - (w_max - w_min)) / 2);

    for j = h_min:h_max
        for k = w_min:w_max
            if (labelled_image(j, k) ~= 0)
                image(j-h_min+offset_h, k-w_min+offset_w) = false;
            end
        end
    end

    segmented_images(:,:,i) = image;
end

end