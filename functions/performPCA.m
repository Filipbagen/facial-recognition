function [score, meanFace, numEigenfaces, eigenfaces, numComponentsRequired] = performPCA(dataMatrix, threshold)
    meanFace = mean(dataMatrix);
    meanCenteredData = dataMatrix - meanFace;
    [coeff, score, latent] = pca(meanCenteredData);

    % Calculate variance explained
    explained = 100 * latent / sum(latent);
    cumulativeVariance = cumsum(explained);

    % Find the number of components required to reach the threshold
    numComponentsRequired = find(cumulativeVariance >= threshold * 100, 1, 'first');

    % If no components meet the threshold, return all
    if isempty(numComponentsRequired)
        numComponentsRequired = length(explained);
    end

    % Select the number of principal components/eigenfaces to use
    numEigenfaces = numComponentsRequired;
    eigenfaces = coeff(:, 1:numEigenfaces);
end