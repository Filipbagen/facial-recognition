function [eyeCoordinates, mouthCoordinate] = face_detection(image)
    
    % Initialize output variables
    eyeCoordinates = [];
    mouthCoordinate = [];

    % Create the face detector
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');

    % Detect the face
    faceBoxes = faceDetector(image);

    % Check if any face is detected
    if isempty(faceBoxes)
        disp('No face detected.');
        return;
    else
        % Use the first detected face
        faceBox = faceBoxes(1, :);
    end

    % Detect eyes and mouth within the face region
    faceImage = imcrop(image, faceBox);
    [eyes, mouth] = find_eyes(faceImage);

    % Check if eyes are detected within the face region
    if isempty(eyes)
        disp('No eyes detected within the face region.');
    else
        % Adjust eye coordinates relative to the original image
        eyeCoordinates = bsxfun(@plus, eyes, faceBox(1:2) - 1);
    end

    % Check if mouth is detected within the face region
    if isempty(mouth)
        disp('No mouth detected within the face region.');
    else
        % Adjust mouth coordinates relative to the original image
        % Assuming mouth is a 1x2 vector [x, y]
        mouthCoordinate = bsxfun(@plus, mouth, faceBox(1:2) - 1);
    end
end
