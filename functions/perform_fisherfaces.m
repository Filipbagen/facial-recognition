function [fisherfaces, ldaCoeff] = perform_fisherfaces(pcaProjectedData, pcaCoeff, numClasses)
    % No need to recalculate PCA inside this function

    % LDA for maximizing class separability
    labels = 1:numClasses; % Creating artificial labels
    pcaDim = size(pcaCoeff, 2);
    
    % Pre-allocate scatter matrices
    Sw = zeros(pcaDim, pcaDim);
    Sb = zeros(pcaDim, pcaDim);
    
    % Compute mean of each class and total mean
    classMeans = arrayfun(@(x) mean(pcaProjectedData(labels == x, :), 1), 1:numClasses, 'UniformOutput', false);
    meanTotal = mean(pcaProjectedData, 1);
    
    % Vectorized computation of scatter matrices
    for i = 1:numClasses
        classData = pcaProjectedData(labels == i, :);
        Sw = Sw + (classData - classMeans{i})' * (classData - classMeans{i});
        Sb = Sb + size(classData, 1) * (classMeans{i} - meanTotal)' * (classMeans{i} - meanTotal);
    end

    % Solve the generalized eigenvalue problem
    [ldaCoeff, eigenvals] = eig(Sb, Sw);
    
    % Sort the eigenvectors based on the eigenvalues
    [~, sortIndex] = sort(diag(eigenvals), 'descend');
    ldaCoeff = ldaCoeff(:, sortIndex);
    
    % Select the top LDA components
    ldaDim = min(numClasses - 1, size(pcaCoeff, 2));
    ldaCoeff = ldaCoeff(:, 1:ldaDim);
    
    % Compute Fisherfaces
    fisherfaces = pcaCoeff * ldaCoeff;
    
end