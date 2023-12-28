function [som_classifier, neuron_labels] = trainSOM(training_features, training_labels, test_features, test_labels)
    % Parameters for SOM
    grid_size = [15, 15];
    som_net = selforgmap(grid_size);
    
    % Train SOM with training features
    som_net = train(som_net, training_features');
    
    % Label each neuron with the majority class of the training samples
    neuron_labels = label_neurons(som_net, training_features, training_labels);
    
    % Classify test samples using the SOM
    predicted_labels = classify_with_som(som_net, neuron_labels, test_features);
    
    % Compute accuracy
    accuracy = sum(grp2idx(predicted_labels) == grp2idx(test_labels)) / length(test_labels) * 100;
    
    fprintf('Accuracy of the SOM model: %.2f%%\n', accuracy);
    
    % Return the trained SOM classifier
    som_classifier = som_net;
end

% Function to label neuons
function neuron_labels = label_neurons(som_net, training_features, training_labels)
    % Get the number of neurons in the SOM
    num_neurons = size(som_net.IW{1}, 1);
    
    % Initialize neuron labels
    neuron_labels = cell(num_neurons, 1);

    % Map each training sample to its BMU
    for i = 1:size(training_features, 1)
        sample = training_features(i, :);
        bmu_index = vec2ind(som_net(sample'));
        
        % Append the label of this sample to the list of labels for this neuron
        if isempty(neuron_labels{bmu_index})
            neuron_labels{bmu_index} = training_labels(i);
        else
            neuron_labels{bmu_index} = [neuron_labels{bmu_index}, training_labels(i)];
        end
    end

    % Determine the most frequent label for each neuron
    for i = 1:num_neurons
        if ~isempty(neuron_labels{i})
            neuron_labels{i} = mode(neuron_labels{i});
        else
            neuron_labels{i} = NaN; 
        end
    end
end

% Function to classify test samples using the labeled SOM
function predicted_labels = classify_with_som(som_net, neuron_labels, test_features)
    num_samples = size(test_features, 1);
    predicted_labels = strings(num_samples, 1); 

    for i = 1:num_samples
        % Find the best matching unit for each test sample
        test_sample = test_features(i, :);
        bmu_index = vec2ind(som_net(test_sample'));

        % Check if the neuron has an assigned label
        if ~isempty(neuron_labels{bmu_index})
            predicted_labels(i) = neuron_labels{bmu_index};
        else
            predicted_labels(i) = "Unknown"; % Assign a default label for unassigned neurons
        end
    end
end

