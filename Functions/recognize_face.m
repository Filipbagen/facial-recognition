function recognize_face(queryWeights, score, folderPath, imageFiles, numEigenfaces)    

    minDistance = inf;
    minIndex = 0;
    
    for i = 1:length(imageFiles)
        distance = norm(score(i,1:numEigenfaces) - queryWeights);
        if distance < minDistance
            minDistance = distance;
            minIndex = i;
        end
    end

    threshold = 5000;

    if minDistance < threshold
        fprintf('The query image matches with image #%d in the training set.\n', minIndex);
        matchedImagePath = fullfile(folderPath, imageFiles(minIndex).name);
        matchedImg = imread(matchedImagePath);
        figure, imshow(matchedImg), title(sprintf('Matched Image: #%d', minIndex));
    else
        fprintf('No match found in the training set for the query image.\n');
    end
end
