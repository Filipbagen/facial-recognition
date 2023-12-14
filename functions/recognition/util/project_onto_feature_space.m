function featureWeights = project_onto_feature_space(inputImage, pcaCoefficients, meanFace, fldCoefficients)
    
    queryImgVector = double(reshape(inputImage, 1, [])); % Reshape the image into a row vector

    % Subtract the mean face from the query image vector
    queryImgVector = queryImgVector - meanFace;

    % Check if dimensions are compatible for matrix multiplication
    if size(queryImgVector, 2) == size(pcaCoefficients, 1)
        % Project onto PCA space
        pcaWeights = queryImgVector * pcaCoefficients;
    else
        error('Dimension mismatch between query image vector and PCA coefficients.');
    end

    % Project onto FLD space if FLD coefficients are provided
    if exist('fldCoefficients', 'var') && ~isempty(fldCoefficients)
        featureWeights = pcaWeights * fldCoefficients;
    else
        featureWeights = pcaWeights;
    end
end
