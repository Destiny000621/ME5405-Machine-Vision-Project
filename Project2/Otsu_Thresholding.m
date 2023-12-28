function Otsu = Otsu_Thresholding(img)
 
% get the histogram, scan all pixels
intensity_level = zeros(1,256);
sz = size(img);
for i = 1:sz(1)
    for j = 1:sz(2)
        z = img(i,j);
        intensity_level(z+1) = intensity_level(z+1) + 1;
    end
end
 
% set the maximum variance, total pixels and sigma value
% maximum_variance = 10^-12;
total_pixels = sum(intensity_level);
sigma = zeros(1,256);
 
% probability levels of pixels
probability_levels = intensity_level / total_pixels;
 
% devide and calculate
for i = 1:128
    p1 = sum(probability_levels(1:i));
    p2 = sum(probability_levels(i+1:end));
    m1 = dot(0:i-1,probability_levels(1:i))   / p1;
    m2 = dot(i:255,probability_levels(i+1:256)) / p2;
    sigma(i) = sqrt(p1*p2*((m1-m2)^2));
 
end 
maximum_variance = max(sigma);
Otsu = find(sigma == maximum_variance, 1)-1;
 
end
 