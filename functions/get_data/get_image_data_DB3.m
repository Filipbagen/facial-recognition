function dataMatrix = get_image_data_DB3(folderPath)

    commonSize = [400, 300];

    % Initialize variables
    dataMatrix = [];
    labels = {};
    errorLog = {}; % Initialize an empty cell array to log errors

    % Get subfolders in the main folder
    subFolders = dir(folderPath);
    subFolders = subFolders([subFolders.isdir]);  % filter out non-directory files
    subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));  % remove . and ..

    figure;

    % Iterate over each subfolder
    for sf = 1:length(subFolders)
        subFolderPath = fullfile(folderPath, subFolders(sf).name);
        imageFiles = dir(fullfile(subFolderPath, '*.jpg'));
        numberOfImages = numel(imageFiles);

        for i = 1:numberOfImages
            % Read image
            img = imread(fullfile(subFolderPath, imageFiles(i).name));
            img = im2double(img);

            % Face detection (implement or modify face_detection function)
            [eyeCoordinates, ~] = face_detection(img);

            % Check if eyes are detected
            if ~isempty(eyeCoordinates)
                % Compensate for rotation
                [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(img, eyeCoordinates);

                % Crop the image
                croppedImage = crop_img(rotatedImage, rotatedEyeCoordinates);
                
                % Convert to grayscale and resize
                grayImg = im2gray(croppedImage);
                resizedImg = imresize(grayImg, commonSize);

                
                imshow(resizedImg);

                % Flatten and insert into the data matrix
                dataMatrix = [dataMatrix; reshape(resizedImg, 1, [])];

                % Assign label based on subfolder name
                labels = [labels; {subFolders(sf).name}];
            else
                % Log error for the current image
                fprintf('No eyes detected in image %s', fullfile(subFolders(sf).name, imageFiles(i).name));
            end
        end
    end

    % At this point, dataMatrix contains all the preprocessed images
    % and labels contains the corresponding labels for each image

    % Save the dataMatrix and labels to a .mat file
    save('faceData_all.mat', 'dataMatrix', 'labels');
end
