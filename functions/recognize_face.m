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

    threshold = 70000;

    if minDistance < threshold
        fprintf('The query image matches with image #%d in the training set.\n', minIndex);
        matchedImagePath = fullfile(folderPath, imageFiles(minIndex).name);
        matchedImg = imread(matchedImagePath);
        figure, imshow(matchedImg), title(sprintf('Matched Image: #%d', minIndex));
    else
        fprintf('No match found in the training set for the query image.\n');
    end
end

% Cosine
% function recognize_face(queryWeights, fisherWeights, folderPath, imageFiles)
%     maxCosineSimilarity = -inf;
%     minIndex = 0;
% 
%     for i = 1:length(imageFiles)
%         cosineSimilarity = dot(fisherWeights(i, :), queryWeights) / (norm(fisherWeights(i, :)) * norm(queryWeights));
%         fprintf('Image #%d similarity: %.2f\n', i, cosineSimilarity);
%         if cosineSimilarity > maxCosineSimilarity
%             maxCosineSimilarity = cosineSimilarity;
%             minIndex = i;
%         end
%     end
% 
% 
%     threshold = 0.5; % Adjust this threshold based on your validation
% 
%     if maxCosineSimilarity > threshold
%         fprintf('The query image matches with image #%d in the training set with a similarity of %.2f.\n', minIndex, maxCosineSimilarity);
%         matchedImagePath = fullfile(folderPath, imageFiles(minIndex).name);
%         matchedImg = imread(matchedImagePath);
%         figure, imshow(matchedImg), title(sprintf('Matched Image: #%d', minIndex));
%     else
%         fprintf('No match found.\n');
%     end
% end

% Eucledian
% function recognize_face(queryWeights, fisherWeights, folderPath, imageFiles)
%     minDistance = inf;
%     minIndex = 0;
% 
%     for i = 1:length(imageFiles)
%         distance = norm(fisherWeights(i, :) - queryWeights);
%         if distance < minDistance
%             minDistance = distance;
%             minIndex = i;
%         end
%     end
% 
%     threshold = 70000; % You might need to adjust this threshold
% 
%     if minDistance < threshold
%         fprintf('The query image matches with image #%d in the training set.\n', minIndex);
%         matchedImagePath = fullfile(folderPath, imageFiles(minIndex).name);
%         matchedImg = imread(matchedImagePath);
%         figure, imshow(matchedImg), title(sprintf('Matched Image: #%d', minIndex));
%     else
%         fprintf('No match found.\n');
%     end
% end

