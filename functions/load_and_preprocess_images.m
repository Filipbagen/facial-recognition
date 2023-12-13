function [dataMatrix, imageFiles] = load_and_preprocess_images(folderPath, commonSize)

    imageFiles = dir(fullfile(folderPath, '*.jpg'));
    numberOfImages = numel(imageFiles);
    dataMatrix = zeros(numberOfImages, prod(commonSize));

    for i = 1:numberOfImages
        figure;
        
        % Read image
        img = imread(fullfile(folderPath, imageFiles(i).name));
        img = im2double(img);

        % Call the face_detection function
        % [eyeCoordinates, mouthCoordinate] = face_detection(img);

        [eyeCoordinates_fd, ~] = face_detection(img);
        [eyeCoordinates_fb, ~] = face_boundary(img);
    
        % Combine and refine results from both methods
        eyeCoordinates = combineResults(eyeCoordinates_fd, eyeCoordinates_fb);
        % mouthCoordinates = combineResults(mouthCoordinates_fd, mouthCoordinates_fb);

        % Compensate for rotation
        [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(img, eyeCoordinates);

        % Crop the image
        croppedImage = crop_img(rotatedImage, rotatedEyeCoordinates);
        
        grayImg = im2gray(croppedImage);
        dataMatrix(i, :) = reshape(grayImg, 1, []);
    end
end




% Helper function to combine and refine results
function combinedCoordinates = combineResults(coordinates1, coordinates2)
    if isempty(coordinates1)
        combinedCoordinates = coordinates2;
    elseif isempty(coordinates2)
        combinedCoordinates = coordinates1;
    else
        % Combine or average the coordinates
        % Modify this part based on your accuracy needs
        combinedCoordinates = (coordinates1 + coordinates2) / 2;
    end
end