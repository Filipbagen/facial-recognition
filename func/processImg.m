function [result] = processImg(image)
    
    % Read image
    img = im2double(image);
    
    % allocate if no face is detected
    result = [];

    % Face detection (implement or modify face_detection function)
    [eyeCoordinates, ~] = face_detection2(img);

        % Check if eyes are detected
        if ~isempty(eyeCoordinates)

            % Compensate for rotation
            [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(img, eyeCoordinates);
        
            % Crop the image
            faceImage = crop_img(rotatedImage, rotatedEyeCoordinates);

            % Convert to grayscale
            result = im2gray(faceImage);
        end
end

