function [fldCoefficients, fldProjectedData] = perform_fld(pcaScore, labels, numComponents)
    
    % Convert labels to numeric if they are not already
    if iscell(labels)
        [~, ~, numericLabels] = unique(labels, 'stable');
        numericLabels = categorical(numericLabels);
    else
        numericLabels = categorical(labels);
    end
    
    % Number of classes
    uniqueLabels = unique(numericLabels);
    numClasses = length(uniqueLabels);
    
    % Compute the mean of the entire dataset
    globalMean = mean(pcaScore, 1);
    
    % Initialize the within-class scatter and between-class scatter matrices
    Sw = zeros(size(pcaScore, 2));
    Sb = zeros(size(pcaScore, 2));
    
    % Compute the scatter matrices
    for i = 1:numClasses
        % Convert i to a categorical value
        currentLabel = uniqueLabels(i);

        % Indices for the current class
        classIdx = numericLabels == currentLabel;
        
        % Score for the current class
        classScore = pcaScore(classIdx, :);
        
        % Mean for the current class
        classMean = mean(classScore, 1);
        
        % Within-class scatter
        Sw = Sw + cov(classScore);
        
        % Between-class scatter
        Sb = Sb + sum(classIdx) * ((classMean - globalMean)' * (classMean - globalMean));
    end
    
    % Solve the generalized eigenvalue problem (Sb*v = lambda*Sw*v)
    [eigenVectors, eigenValuesMatrix] = eig(Sb, Sw);
    
    % Extract the eigenvalues from the diagonal matrix
    eigenValues = diag(eigenValuesMatrix);

    % Sort the eigenvectors by their eigenvalues in descending order
    [~, sortedIndices] = sort(abs(eigenValues), 'descend');
    eigenVectors = eigenVectors(:, sortedIndices);
    
    % Select the number of components for the FLD
    fldCoefficients = eigenVectors(:, 1:numComponents);
    
    % Project the PCA scores onto the FLD space
    fldProjectedData = pcaScore * fldCoefficients;
end
