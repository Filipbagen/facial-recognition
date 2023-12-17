% im is the image to be classified 
% method is either 'eigenfaces' or 'fisherfaces'

function id = tnm034(im, method)

    % runs only once
    [dataMatrix_all, labels, SVMModel, dataMatrix_DB1] = init();

    % classify using eigenfaces and eucledian distance
    if strcmp(method, 'eigenface')

        % detect the eyes using image processing
        [eyeCoordinates, ~] = face_boundary(im);
        % [eyeCoordinates, ~] = face_detection(im);

        if ~isempty(eyeCoordinates)

            % Compensate for rotation
            [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(im, eyeCoordinates);

            % Convert to grayscale
            grayImg = im2gray(rotatedImage);
            
            % Crop the image
            croppedImage = crop_img(grayImg, rotatedEyeCoordinates);

            % Perform PCA
            [~, meanFace, ~, score, eigenfaces, numEigenValues] = perform_pca(dataMatrix_DB1);

            % Project onto eigenfaces
            queryWeights = project_onto_eigenfaces(croppedImage, eigenfaces, meanFace);

            % Recognize the face
            id = recognize_face_eigen(queryWeights, score, numEigenValues);
        else

            id = 0;
        end
    
    % fisher linear discriminant method
    elseif strcmp(method, 'fisherface')

        im = im2double(im);

        % compensate for tone variations
        % compensated = tone_compensation(im);
        compensated = im;
    
        % Const
        confidenceThreshold = 0.03; % Distance between face and hyperplane
        
        % Initialize croppedImg
        croppedImg = [];
    
        % Face detection (implement or modify face_detection function)
        [eyeCoordinates, ~] = face_detection(compensated);
    
        % Check if eyes are detected
        if ~isempty(eyeCoordinates)
    
            % Compensate for rotation
            [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(compensated, eyeCoordinates);
    
            % Convert to grayscale
            grayImg = im2gray(rotatedImage);
        
            % Crop the image
            croppedImg = crop_img(grayImg, rotatedEyeCoordinates);
        end            

        % set face to unknown if no eyes are detected
        if isempty(croppedImg)
            id = 0;
         
        else % continue if the eyes are found
    
            % Perform PCA
            [reducedData, meanFace, pcaCoefficients, ~, ~] = perform_pca(dataMatrix_all);

            % Perform FLD on the PCA score
            [fldCoefficients, ~] = perform_fld(reducedData, labels);

            % Process a new query image (inputImage)
            queryWeights = project_onto_feature_space(croppedImg, pcaCoefficients, meanFace, fldCoefficients);

            %  Use the SVM model to recognize the face with thresholding
            matchedLabel = recognize_face_svm(queryWeights, SVMModel, confidenceThreshold);

            % id = str2double(matchedLabel);
            id = matchedLabel;
        end
        
    else 
        fprintf('Undefined method')
    end

end

