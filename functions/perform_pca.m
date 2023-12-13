function [score, meanFace, coeff] = perform_pca(dataMatrix, threshold)
    meanFace = mean(dataMatrix);
    meanCenteredData = dataMatrix - meanFace;
    [coeff, score, latent] = pca(meanCenteredData);

    % Calculate variance explained
    explained = 100 * latent / sum(latent);
    cumulativeVariance = cumsum(explained);

    % Find the number of components required to reach the threshold. 
    % Not used in the code
    numComponentsRequired = find(cumulativeVariance >= threshold * 100, 1, 'first')
end