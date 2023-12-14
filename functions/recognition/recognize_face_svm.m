function matchedLabel = recognize_face_svm(queryWeight, SVMModel, confidenceThreshold)
    % Predict the label of the query image and get the decision scores
    [predictedLabel, scores] = predict(SVMModel, queryWeight);

    % Find the score with the maximum absolute value
    [maxScore, ~] = max(abs(scores), [], 2);

    % Check if the maximum confidence score meets the threshold
    if maxScore < confidenceThreshold
        matchedLabel = 0; % Indicate uncertain recognition
    else
        % Since predictedLabel is a scalar, no need to index it
        if iscategorical(predictedLabel)
            predictedLabelStr = char(predictedLabel);

        elseif iscell(predictedLabel)
            predictedLabelStr = predictedLabel{1};
        else
            % If labels are numeric or another format, convert to string
            predictedLabelStr = num2str(predictedLabel);
        end

        matchedLabel = predictedLabelStr;
    end
end
