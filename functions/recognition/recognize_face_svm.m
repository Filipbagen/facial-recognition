function matchedLabel = recognize_face_svm(queryWeight, SVMModel, confidenceThreshold)
    % Predict the label of the query image and get the decision scores
    [predictedLabel, scores] = predict(SVMModel, queryWeight);

    % Find the score with the maximum absolute value
    [maxScore, ~] = max(abs(scores), [], 2);

    % Check if the maximum confidence score meets the threshold
    if maxScore < confidenceThreshold
        matchedLabel = 0; % Indicate uncertain recognition as digit 0
    else
        % Directly use the predicted label if it's numeric
        matchedLabel = predictedLabel;
        
        % If predictedLabel is not numeric (e.g., categorical), convert it to a number
        if ~isnumeric(predictedLabel)
            matchedLabel = str2double(char(predictedLabel));
        end
    end
end
