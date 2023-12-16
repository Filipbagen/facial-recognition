function featureWeights = project_onto_feature_space(inputImage, pcaCoefficients, meanFace, fldCoefficients)
    
    queryImgVector = double(reshape(inputImage, 1, [])); % Reshape the image into a row vector

    % Subtract the mean face from the query image vector
    queryImgVector = queryImgVector - meanFace;

    % Project onto PCA space
    pcaWeights = queryImgVector * pcaCoefficients;

    % Project onto FLD space if FLD coefficients are provided
    if nargin > 3 && ~isempty(fldCoefficients)
        featureWeights = pcaWeights * fldCoefficients;
    else
        featureWeights = pcaWeights;
    end
end
