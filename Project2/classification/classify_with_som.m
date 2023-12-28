% Function to classify test samples using the labeled SOM
function predicted_labels = classify_with_som(som_net, neuron_labels, test_features)
    num_samples = size(test_features, 1);
    predicted_labels = strings(num_samples, 1); % Preallocate for efficiency

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