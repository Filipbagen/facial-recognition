function matchedLabel = recognizeFace(queryWeights, databaseFeatures, databaseLabels, threshold)
    % Calculate distances from the query to all database features
    distances = pdist2(queryWeights, databaseFeatures, 'euclidean');
    
    % Find the nearest neighbor
    [minDistance, minIndex] = min(distances);

    

    % Threshold to determine if a match is found
    if nargin < 4
        threshold = 10; % Adjust threshold as needed
    end

    if minDistance < threshold
        % Access label based on data type
        if iscell(databaseLabels)
            matchedLabel = databaseLabels{minIndex};
        else
            matchedLabel = databaseLabels(minIndex);
        end
    else
        matchedLabel = 0;
    end
end
