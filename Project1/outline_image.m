function outline_image(binary_img)
    [m, n] = size(binary_img);
    outline_img = zeros(m,n);
 
    % row operation
    for i = 1:m
        for j = 2:n-1
            if binary_img(i,j) > binary_img(i, j+1)
                outline_img(i,j) = 1;
            end
            if binary_img(i,j) > binary_img(i, j-1)
                outline_img(i, j-1) = 1;
            end
        end
    end
    
    % column operation
    for i = 2:m-1
        for j = 1:n
            if binary_img(i,j) > binary_img(i+1, j)
                outline_img(i,j) = 1;
            end
            if binary_img(i,j) > binary_img(i-1, j)
                outline_img(i-1, j) = 1;
            end
        end
    end
    
    imshow(outline_img,'InitialMagnification','fit');
end
 