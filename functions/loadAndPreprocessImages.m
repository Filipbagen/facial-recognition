function [dataMatrix, imageFiles] = loadAndPreprocessImages(folderPath, numImages, commonSize)
    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    dataMatrix = zeros(numImages, prod(commonSize));

    for i = 1:numImages
        img = imread(fullfile(folderPath, imageFiles(i).name));
        grayImg = im2gray(img);
        resizedImg = imresize(grayImg, commonSize);
        dataMatrix(i, :) = reshape(resizedImg, 1, []);
    end
end
