%% 1. Open and display the original image
chromo = fopen('chromo.txt');              
lf = newline;                              % line feed character
cr = char(13);                             % carriage return character
ch = fscanf(chromo,[cr lf '%c'],[64, 64]); % put in 64X64 matrix
fclose(chromo);                           
 
ch = ch';                                  % transpose since fscanf returns column vectors
ch(isletter(ch)) = ch(isletter(ch)) - 55;  % convert letters A‐V to their corresponding values in 32 gray levels
ch(ch >= '0' & ch <= '9') = ch(ch >= '0' & ch <= '9') - 48; % convert number 0‐9 to their corresponding values in 32 gray levels
ch = uint8(ch);                            % uint8 in range(0-255), 8-bit unsigned integer, 1 byte
img = ch;

% display the appropriate size image
imshow(img,[0 32],'InitialMagnification','fit'); 
title('Original image：');

%% 2. Threshold the image and convert it into binary image
figure;

subplot(1,2,1);
GT = Global_Thresholding(img);
imshow(img > GT,'InitialMagnification','fit'); 
title(['Global Thresholding at: ', num2str(GT)]);

subplot(1,2,2);
Otsu = Otsu_Thresholding(img);
imshow(img > Otsu,'InitialMagnification','fit');  
title(['Otsu Thresholding at: ', num2str(Otsu)]);

%% 3.Determine a one-pixel thin image of the objects
figure();
 
subplot(1,2,1);
one_pixel_image(img < GT);
title('Thinned image with Global Thresholding：');
subplot(1,2,2);
one_pixel_image(img < Otsu);
title('Thinned image with Otsu Thresholding：');
  
%% 4.Determine the outline(s)
figure;
 
subplot(1,2,1);
outline_image(img < GT);
title('Outlined image with Global Thresholding：');
subplot(1,2,2);
outline_image(img < Otsu);
title('Outlined image with Otsu Thresholding：');
 
%% 5. Label the different objects
figure();
 
subplot(2,2,1);
[out_img,num] = twopass_4_connectivity(img < GT);                          
img_rgb = label2rgb(out_img, 'jet', [0 0 0], 'shuffle');  % jet colormap 
imshow(img_rgb,'InitialMagnification','fit');
title({'Two Pass method with 4 connectivity, using Global Thresholding: ';['Label numbers: ',num2str(num)]});

subplot(2,2,2);
[out_img,num] = twopass_8_connectivity(img < GT);                          
img_rgb = label2rgb(out_img, 'jet', [0 0 0], 'shuffle');
imshow(img_rgb,'InitialMagnification','fit');
title({'Two Pass method with 8 connectivity, using Global Thresholding: ';['Label numbers: ',num2str(num)]});

subplot(2,2,3);
[out_img,num] = twopass_4_connectivity(img < Otsu);                          
img_rgb = label2rgb(out_img, 'jet', [0 0 0], 'shuffle'); 
imshow(img_rgb,'InitialMagnification','fit');
title({'Two Pass method with 4 connectivity, using Otsu Thresholding: ';['Label numbers: ',num2str(num)]});

subplot(2,2,4);
[out_img,num] = twopass_8_connectivity(img < Otsu);                          
img_rgb = label2rgb(out_img, 'jet', [0 0 0], 'shuffle');
imshow(img_rgb,'InitialMagnification','fit');
title({'Two Pass method with 8 connectivity, using Otsu Thresholding: ';['Label numbers: ',num2str(num)]});

%% 6. Rotate the original image by 30 degrees, 60 degrees and 90 degrees respectively
figure();

subplot(1,3,1);
rotation(img, 30);
title('Rotate 30 degrees');
subplot(1,3,2);
rotation(img, 60);
title('Rotate 60 degrees');
subplot(1,3,3);
rotation(img, 90);
title('Rotate 90 degrees');
