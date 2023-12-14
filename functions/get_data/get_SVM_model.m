% This function is only in order to recreate the training data
function get_SVM_model()
    
    % load the dataset
    load('faceData_all.mat', 'dataMatrix', 'labels');

    % number of faces
    numClasses = 16;
    numFldComponents = numClasses - 1;

    % Perform PCA
    [reducedData, ~, ~, ~, ~] = perform_pca(dataMatrix);
    
    % Perform FLD on the PCA score
    [~, fldProjectedData] = perform_fld(reducedData, labels, numFldComponents);
    
    % Convert labels to categorical
    labels = categorical(labels);
    
    % Split the dataset into training and testing sets
    cv = cvpartition(size(fldProjectedData, 1), 'HoldOut', 0.2);
    
    idx = cv.test;
    % Separate to training and test data
    trainData = fldProjectedData(~idx,:);
    trainLabels = labels(~idx);
    
    % Train the classifier, for example, an SVM
    SVMModel = fitcecoc(trainData, trainLabels, 'Learners', 'svm', 'Coding', 'onevsall', 'Prior', 'uniform');

    save('trainedModel.mat', 'SVMModel', 'trainData', 'trainLabels');
end

