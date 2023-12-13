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

    % Crop the detected face region from the image
    faceImage = imcrop(image, faceBox);

    % Create eye and mouth detectors
    eyeDetector = vision.CascadeObjectDetector('EyePairBig');
    mouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 12);

    % Detect eyes and mouth within the face region
    eyeBoxes = eyeDetector(faceImage);
    mouthBoxes = mouthDetector(faceImage);

    % Check if eyes are not detected within the face region
    if isempty(eyeBoxes)
        disp('No eyes detected within the face region.');
    else
        % Use the first detected eyes
        eyeBox = eyeBoxes(1, :);

        % Estimate the centers of the left and right eyes
        eyeWidth = eyeBox(3) / 2;
        eyeHeight = eyeBox(4);

        % Calculate the center coordinates for each eye
        leftEyeCenter = [eyeBox(1) + eyeWidth / 2, eyeBox(2) + eyeHeight / 2];
        rightEyeCenter = [eyeBox(1) + 3 * eyeWidth / 2, eyeBox(2) + eyeHeight / 2];

        % Adjust eye center coordinates relative to the original image
        eyeCoordinates = bsxfun(@plus, [leftEyeCenter; rightEyeCenter], faceBox(1:2) - 1);
    end

    % Check if mouth is detected within the face region
    if isempty(mouthBoxes)
        disp('No mouth detected within the face region.');
    else
        % Use the first detected mouth
        mouthBox = mouthBoxes(1, :);

        % Calculate width (w) and height (h) of the mouth bounding box
        w = mouthBox(3);
        h = mouthBox(4);

        % Calculate the center of the mouth bounding box
        centerX = mouthBox(1) + w / 2;
        centerY = mouthBox(2) + h / 2;

        % Adjust mouth center coordinates relative to the original image
        mouthCoordinate = bsxfun(@plus, [centerX, centerY], faceBox(1:2) - 1);
    end
end



