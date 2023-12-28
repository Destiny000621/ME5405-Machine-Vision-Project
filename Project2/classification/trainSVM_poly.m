% Function for training of Support Vector Machine for classification.

function [svm_classifier, accuracy] = trainSVM_poly(training_features,training_labels,test_features,test_labels, kernelFunction, boxconstraints, kernelscales, polynomialorders)
% KernelFunction: "polynomial"
% boxConstraints = [0.1, 1, 10, 100];
% kernelScales = ['auto', 0.5, 1, 2];
% polynomialOrders = [2, 3, 4];

% Check if the kernel function is polynomial before adding PolynomialOrder
if strcmp(kernelFunction, 'polynomial')
    t = templateSVM('KernelFunction', kernelFunction, 'BoxConstraint', boxconstraints, 'KernelScale', kernelscales, 'PolynomialOrder', polynomialorders);
else
    t = templateSVM('KernelFunction', kernelFunction, 'BoxConstraint', boxconstraints, 'KernelScale', kernelscales);
end

% fit multiclass SVM
svm_classifier = fitcecoc(training_features,training_labels,"Learners", t,"Coding","onevsall");

% predict labels of test set
predicted_labels = predict(svm_classifier, test_features);

% compute accuracy
accuracy = sum(predicted_labels == test_labels) / length(test_labels) * 100;
    
%fprintf('Accuracy of the SVM model: %.2f%%\n', accuracy);

% confusion matrix
%figure(14);
%plotconfusion(test_labels, predicted_labels);

end