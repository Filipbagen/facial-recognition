function matchedLabel = recognizeFaceCombined(queryWeights, databaseFeatures, databaseLabels, SVMModel, distanceThreshold, svmConfidenceThreshold)
    % Predict the label of the query image using the trained SVM model
    [predictedLabel, score] = predict(SVMModel, queryWeights);
    
    % Find the score with the maximum absolute value
    [maxScore, ~] = max(abs(score), [], 2);
    
    % Check if the SVM's maximum confidence score meets its threshold
    if maxScore >= svmConfidenceThreshold

        % SVM is confident, use its prediction
        if iscell(predictedLabel)
            matchedLabel = predictedLabel{1};
        else
            matchedLabel = predictedLabel;
        end
        fprintf('SVM confident: Predicted label: %s with confidence: %f\n', matchedLabel, maxScore);
    else
        % SVM is not confident, fall back to nearest neighbor approach
        distances = pdist2(queryWeights, databaseFeatures, 'euclidean');
        [minDistance, minIndex] = min(distances);

        % Check if the nearest neighbor distance meets the threshold
        if minDistance < distanceThreshold

            if iscell(databaseLabels)
                matchedLabel = databaseLabels{minIndex};
            else
                matchedLabel = databaseLabels(minIndex);
            end
            fprintf('Nearest neighbor: Predicted label: %s with distance: %f\n', matchedLabel, minDistance);
        else
            % No match found within threshold
            matchedLabel = 0;
            disp('No match found within thresholds.\n');
        end
    end
end
