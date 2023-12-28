function Output_image = one_pixel_image(binary_img)
    % Zhang_Suen_Thinning
    % get the binary image    
    [m, n] = size(binary_img);             % get the image size
    img = padarray(binary_img, [1 1], 0);  % padding the image
    en = 0;   % define the enable signal
    [obj_row,obj_col] = find(binary_img == 1);
 
    while en ~= 1 
        tmp_img = img;
 
        % Step 1
        for p = 2:length(obj_row)
            % for b = 2:length(obj_cols)
 
            rand_array = randperm(length(obj_row));
            i = obj_row(rand_array(1));
            j = obj_col(rand_array(1));
 
            if i == 1 || i == m
                continue
            elseif j == 1 || j == n
                continue
            end
 
            % get the pixel, order is: P1,P2,P3...P8,P9,P2
            core_pixel  = [img(i,j)     img(i-1,j)   img(i-1,j+1) ...
                           img(i,j+1)   img(i+1,j+1) img(i+1,j)   ...
                           img(i+1,j-1) img(i,j-1)   img(i-1,j-1) ... 
                           img(i-1,j)];
 
            A_P1 = 0;    % value change times
            B_P1 = 0;    % non zero neighbors
            for k = 2:9
                if core_pixel (k) < core_pixel (k+1)
                    A_P1 = A_P1 + 1;
                end
                if core_pixel (k) == 1
                    B_P1 = B_P1 + 1;
                end
            end
                
            if ((core_pixel(1) == 1)                                    &&...
                   (A_P1 == 1)                                          &&...
                   ((B_P1 >= 2) && (B_P1 <= 6))                         &&...
                   (core_pixel(2) * core_pixel(4) * core_pixel(6) == 0) &&...
                   (core_pixel(4) * core_pixel(6) * core_pixel(8) == 0))
               img(i, j) = 0;
            end
        end
        
        % when previous image is equal to current image, break the loop
        en = isequal(tmp_img, img);
        if en      
           break
        end
        
 %---------------------------------------------------------------------------------
        tmp_img = img;
        % Step 2        
        for p = 2:length(obj_row)
            % for b = 2:length(obj_cols)
 
            rand_array=randperm(length(obj_row));
            i = obj_row(rand_array(1));
            j = obj_col(rand_array(1));
 
            if i== 1 || i == m
                continue
            elseif j==1 || j== n
                continue
            end
 
            core_pixel  = [img(i,j)     img(i-1,j)   img(i-1,j+1) ...
                           img(i,j+1)   img(i+1,j+1) img(i+1,j)   ...
                           img(i+1,j-1) img(i,j-1)   img(i-1,j-1) ... 
                           img(i-1,j)];
 
            A_P1 = 0;
            B_P1 = 0;
            for k = 2:9
                if core_pixel (k) < core_pixel (k+1)
                    A_P1 = A_P1 + 1;
                end
                if core_pixel (k) == 1
                    B_P1 = B_P1 + 1;
                end
            end
 
            if ((core_pixel(1) == 1)                                    &&...
                   (A_P1 == 1)                                          &&...
                   ((B_P1 >= 2) && (B_P1 <= 6))                         &&...
                   (core_pixel(2) * core_pixel(4) * core_pixel(8) == 0) &&...
                   (core_pixel(2) * core_pixel(6) * core_pixel(8) == 0))
               img(i, j) = 0;
            end
        end
        
        % when previous image is equal to current image, break the loop
        en = isequal(tmp_img, img);
        if en      
           break
        end
    end
 
    img_thinned = [m,n];
    img = 1 - img;
    for i = 2:m+1
        for j = 2:n+1
            img_thinned(i-1, j-1) = img(i,j);
        end
    end
 
    % 返回细化后的图像，而不是显示它
    Output_image = img_thinned;
end
 