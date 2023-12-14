% function [reducedData, meanFace, pcaCoefficients, score, eigenfaces, numComponentsRequired] = perform_pca(dataMatrix)
% 
%     meanFace = mean(dataMatrix);
%     meanCenteredData = dataMatrix - meanFace;
%     [coeff, score, latent] = pca(meanCenteredData);
% 
%     % Calculate variance explained
%     explained = 100 * latent / sum(latent);
%     cumulativeVariance = cumsum(explained);
% 
%     % Find the number of components required to reach the threshold
%     numComponentsRequired = find(cumulativeVariance >= 0.9 * 100, 1, 'first');  % Keep 90% of the data
% 
%     % If no components meet the threshold, return all
%     if isempty(numComponentsRequired)
%         numComponentsRequired = length(explained);
%     end
% 
%     % Always calculate reduced data and eigenfaces
%     pcaCoefficients = coeff(:, 1:numComponentsRequired);
%     reducedData = meanCenteredData * pcaCoefficients;
%     eigenfaces = coeff(:, 1:numComponentsRequired);
% end
% 

function [reducedData, meanFace, pcaCoefficients, score, eigenfaces, numComponentsRequired] = perform_pca(dataMatrix)

    % Existing PCA implementation
    meanFace = mean(dataMatrix);
    meanCenteredData = dataMatrix - meanFace;
    [coeff, score, latent] = pca(meanCenteredData);

    % Calculate variance explained
    explained = 100 * latent / sum(latent);
    cumulativeVariance = cumsum(explained);

    % Find the number of components required to reach the threshold
    numComponentsRequired = find(cumulativeVariance >= 0.9 * 100, 1, 'first');  % Keep 90% of the data
    
    % If no components meet the threshold, return all
    if isempty(numComponentsRequired)
        numComponentsRequired = length(explained);
    end

    pcaCoefficients = coeff(:, 1:numComponentsRequired);
    reducedData = meanCenteredData * pcaCoefficients;
    eigenfaces = coeff(:, 1:numComponentsRequired);
end


