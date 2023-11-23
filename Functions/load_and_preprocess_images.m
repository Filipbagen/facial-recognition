function [dataMatrix, imageFiles] = load_and_preprocess_images(folderPath, commonSize)

    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    numberOfImages = numel(imageFiles);
    dataMatrix = zeros(numberOfImages, prod(commonSize));

    for i = 1:numberOfImages
        img = imread(fullfile(folderPath, imageFiles(i).name));
        grayImg = im2gray(img);
        resizedImg = imresize(grayImg, commonSize);
        dataMatrix(i, :) = reshape(resizedImg, 1, []);
    end
end
