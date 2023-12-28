function GT = Global_Thresholding(img)
 
T = 20;                 % define initial estimate value
T0 = 0;
 
G1 = img >  T;
G2 = img <= T;          % use T to get 2 groups of pixels
ave1 = mean(img(G1)); 
ave2 = mean(img(G2));   % get the mean value
 
while abs(T-T0) > (10^-10)  
    T0 = T;
    T   = (ave1 + ave2)/2;
    G1  = img >  T;
    G2  = img <= T;
    ave1 = mean(img(G1));
    ave2 = mean(img(G2));
end
 
GT = T;
end
 