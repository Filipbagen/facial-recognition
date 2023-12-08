function [dataMatrix, imageFiles] = load_and_preprocess_images(folderPath, commonSize)

    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    numberOfImages = numel(imageFiles);
    dataMatrix = zeros(numberOfImages, prod(commonSize));

    for i = 1:numberOfImages
        % Read image
        img = imread(fullfile(folderPath, imageFiles(i).name));

        % Call the face_detection function
        [eyeCoordinates, mouthCoordinate] = face_detection(img);

        % Compensate for rotation
        [rotatedImage, rotatedEyeCoordinates, rotatedMouthCoordinate] = rotation_compensation(img, eyeCoordinates, mouthCoordinate);

        % Crop the image
        croppedImage = crop_img(rotatedImage, rotatedEyeCoordinates, rotatedMouthCoordinate);
        imshow(croppedImage)
        
        grayImg = im2gray(croppedImage);
        dataMatrix(i, :) = reshape(grayImg, 1, []);
    end
end