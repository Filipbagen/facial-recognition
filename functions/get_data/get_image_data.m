function get_image_data(folderPath, commonSize)

    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    numberOfImages = numel(imageFiles);
    dataMatrix_DB1 = zeros(numberOfImages, prod(commonSize));

    for i = 1:numberOfImages
        
        % Read image
        img = imread(fullfile(folderPath, imageFiles(i).name));
        img = im2double(img);

        % Call the face_detection function
        [eyeCoordinates, ~] = face_detection(img);

        % Compensate for rotation
        [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(img, eyeCoordinates);

        % Crop the image
        croppedImage = crop_img(rotatedImage, rotatedEyeCoordinates);
        
        grayImg = im2gray(croppedImage);

        figure;
        imshow(grayImg);

        dataMatrix_DB1(i, :) = reshape(grayImg, 1, []);
    end

    save('dataMatrix_DB1.mat', 'dataMatrix_DB1');
end