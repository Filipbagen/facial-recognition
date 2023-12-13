function id = tnm034(im)
    
    % Const
    threshold = 0.9;  % Threshold for variance explanation (90%)
    numClasses = 16;
    numFldComponents = numClasses - 1;
    confidenceThreshold = 0.01; % Distance between face and hyperplane
    

    % Load data
    face_data = load('faceData.mat', 'dataMatrix', 'labels');
    addpath('func');
    addpath('functions');


    % Compensated image
    compensated = tone_compensation(im);
    cropped_img = processImg(compensated);

    % if algorithm finds eyes
    if ~isempty(cropped_img)
        % Perform PCA
        [score, meanFace, pcaCoefficients] = perform_pca(face_data.dataMatrix, threshold);
    
        % Perform FLD on the PCA score
        [fldCoefficients, fldProjectedData] = perform_fld(score, face_data.labels, numFldComponents);
    
        % Convert labels to categorical
        labels = categorical(face_data.labels);
        
        % Split the dataset into training and testing sets
        cv = cvpartition(size(fldProjectedData, 1), 'HoldOut', 0.2);
    
        idx = cv.test;
        % Separate to training and test data
        trainData = fldProjectedData(~idx,:);
        trainLabels = labels(~idx);
        
        % Train the classifier, for example, an SVM
        SVMModel = fitcecoc(trainData, trainLabels, 'Learners', 'svm', 'Coding', 'onevsall', 'Prior', 'uniform');
    
        % Process a new query image (inputImage)
        queryWeights = projectOntoFeatureSpace(cropped_img, pcaCoefficients, meanFace, fldCoefficients);
        
        %  Use the SVM model to recognize the face with thresholding
        matchedLabel = recognizeFaceSVM(queryWeights, SVMModel, confidenceThreshold);
    
        id = str2double(matchedLabel);

    else
        id = 0;
    end
end

