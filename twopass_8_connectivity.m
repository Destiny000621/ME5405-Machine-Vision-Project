function [out_img,num] = twopass_8_connectivity(binary_img)
    [height, width] = size(binary_img);
    out_img = double(binary_img);
    labels = 1;
 
    % first pass
    for i = 1:height
        for j = 1:width
            if binary_img(i,j) > 0  % processed the point
                neighbors = [];     % get the neighborhood, define as: rows, columns, values
                if (i-1 > 0)
                     if (j-1 > 0 && binary_img(i-1,j-1) > 0)
                         neighbors = [neighbors; i-1, j-1, out_img(i-1,j-1)];
                     end
                     if binary_img(i-1,j) > 0
                         neighbors = [neighbors; i-1, j, out_img(i-1,j)];
                     end
                elseif (j-1) > 0 && binary_img(i,j-1) > 0
                    neighbors = [neighbors; i, j-1, out_img(i,j-1)];
                end
 
                if isempty(neighbors)
                    labels = labels + 1;
                    out_img(i,j) = labels;
                else
                    out_img(i,j) = min(neighbors(:,3));
                    % The third column of neighbors is the value of the upper or left point, 
                    % output is the smaller value of the upper and left label
                end
            end
        end
    end
 
    % second pass
    [row, col] = find( out_img ~= 0 ); % point coordinate (row(i), col(i))   
    for i = 1:length(row)
        if row(i)-1 > 0
            up = row(i)-1;
        else
            up = row(i);
        end
 
        if row(i)+1 <= height
            down = row(i)+1;
        else
            down = row(i);
        end
 
        if col(i)-1 > 0
            left = col(i)-1;
        else
            left = col(i);
        end
 
        if col(i)+1 <= width
            right = col(i)+1;
        else
            right = col(i);
        end
 
        % 8 connectivity
        connection = out_img(up:down, left:right);
        
        [r1, c1] = find(connection ~= 0); 
        % in the neighborhood, find coordinates that ~= 0 
        
        if ~isempty(r1)
            connection = connection(:);          % convert to 1 column vector
            connection(connection == 0) = [];    % remove non-zero value
 
            min_label_value = min(connection);   % find the min label value
            connection(connection == min_label_value) = [];    
            % remove the connection that equal to min_label_value
 
            for k = 1:1:length(connection)
                out_img(out_img == connection(k)) = min_label_value;    
                % Change the original value of k in out_img to min_label_value
            end
        end
    end
 
    u_label = unique(out_img);     % get all the unique label values in out_img
    for i = 2:1:length(u_label)
        out_img(out_img == u_label(i)) = i-1;  % reset the label value: 1, 2, 3, 4......
    end
    
    label_num = unique(out_img(out_img > 0));
    num = numel(label_num);  % numel function gives the pixel numbers
 
end
 