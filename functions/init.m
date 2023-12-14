function [dataMatrix, labels, SVMModel, dataMatrix_DB1] = init()
    persistent isLoaded dataMatrix_p labels_p SVMModel_p dataMatrix_DB1_p

    if isempty(isLoaded)

        % load path
        addpath(genpath('functions'));
        addpath('data');


        % load data
        load('faceData_all.mat', 'dataMatrix', 'labels');
        load('trainedModel.mat', 'SVMModel');
        load('dataMatrix_DB1.mat', 'dataMatrix_DB1');

        % assign to persistent variables
        dataMatrix_p = dataMatrix;
        labels_p = labels;
        SVMModel_p = SVMModel;
        dataMatrix_DB1_p = dataMatrix_DB1;

        % set flag to indicate data is loaded
        isLoaded = true;
    else
        % Use the persistent variables
        dataMatrix = dataMatrix_p;
        labels = labels_p;
        SVMModel = SVMModel_p;
        dataMatrix_DB1 = dataMatrix_DB1_p;
    end
end
