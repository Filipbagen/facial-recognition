% function predictedLabel = recognize_face_eigen(queryWeights, score, numEigenfaces)
% 
%     minDistance = inf;
%     minIndex = 0;
% 
%     % i represents each class
%     for i = 1:size(score, 1)
%         distance = norm(score(i,1:numEigenfaces) - queryWeights);
%         if distance < minDistance
%             minDistance = distance;
%             minIndex = i;
%         end
%     end
% 
%     threshold = 60000;
%     % threshold = 5000;
% 
%     if minDistance < threshold
%         predictedLabel = minIndex;
% 
%     else
%         predictedLabel = 0;
%     end
% end


function predictedLabel = recognize_face_eigen(queryWeights, score, numEigenfaces)

    minDistance = inf;
    minIndex = 0;
    
    % i represents each class
    for i = 1:size(score, 1)
        distance = norm(score(i,1:numEigenfaces) - queryWeights);
        if distance < minDistance
            minDistance = distance;
            minIndex = i;
        end
    end

    % threshold = 14000;
    threshold = 5000;

    if minDistance < threshold
        predictedLabel = minIndex;

    else
        predictedLabel = 0;
    end
end