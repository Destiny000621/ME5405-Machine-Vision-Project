% Function for training of k-nearest neighbor for classification.

function [knn_classifier, accuracy] = trainKNN(train_features,train_labels,test_features,test_labels, distance, n, standardize, distanceWeight)
%Distance: 'euclidean', 'cityblock', 'minkowski'
%NumNeighbors: n
%Standardize: 0(false) or 1(true)
%DistanceWeight: 'equal', 'inverse', 'squaredinverse'

% KNN classifier
knn_classifier = fitcknn(train_features, train_labels, 'Distance', distance, 'NumNeighbors', n, 'Standardize',standardize, 'DistanceWeight', distanceWeight);

% predict labels of test set
predicted_labels = predict(knn_classifier, test_features);

% compute accuracy
accuracy = sum(predicted_labels == test_labels) / length(test_labels) * 100;
    
fprintf('Accuracy of the KNN model: %.2f%%\n', accuracy);

% confusion matrix
figure(5);
plotconfusion(test_labels, predicted_labels);

end