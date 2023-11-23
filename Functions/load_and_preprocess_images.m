function [dataMatrix, imageFiles] = load_and_preprocess_images(folderPath, commonSize)

    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    numberOfImages = numel(imageFiles);
    dataMatrix = zeros(numberOfImages, prod(commonSize));

    for i = 1:numberOfImages
        img = imread(fullfile(folderPath, imageFiles(i).name));

        % Rotates the image (max +/-5 degrees),
        % img1 = random_rotate(img);
        
        % Scales the image (max +/- 10%)
        % img2 = random_scale(img1);
        
        % Adjusts tone(contrast and brightness) and temperature (max +/- 30%)
        img = random_tone(img);

        grayImg = im2gray(img);
        resizedImg = imresize(grayImg, commonSize);
        dataMatrix(i, :) = reshape(resizedImg, 1, []);
    end
end
