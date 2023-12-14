function [eyeCoordinates, mouthCoordinate] = face_detection(image)

    % Initialize output variables
    eyeCoordinates = [];
    mouthCoordinate = [];

    % Create the face detector
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
    faceDetector.ScaleFactor = 2;

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
    % mouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 12);

    eyeDetector.MergeThreshold = 1;
    % Detect eyes and mouth within the face region
    eyeBoxes = eyeDetector(faceImage);
    % mouthBoxes = mouthDetector(faceImage);

    if isempty(eyeBoxes)
        disp('No eyes detected within the face region.');

    else
        % Use the first detected eye pair
        eyeBox = eyeBoxes(1, :);
    
        % Crop the eye region from the face image
        eyeRegion = imcrop(faceImage, eyeBox);

        % Convert to grayscale and apply median filter (if necessary)
        grayEyeRegion = rgb2gray(eyeRegion);
        filteredEyeRegion = medfilt2(grayEyeRegion);
    
        minRadius = 10;
        maxRadius = 100;
    
        % Apply Circular Hough Transform to detect irises
        centers = imfindcircles(filteredEyeRegion, [minRadius maxRadius], ...
                                                 'ObjectPolarity', 'dark', ...
                                                 'Sensitivity', 0.9);
    
        % Validate and refine the detected circles to select the best candidates
        % [logic to select and validate the best two circles for irises]
    
        % Adjust iris center coordinates relative to the original image
        if size(centers, 1) == 2

            % Sort the centers based on x-coordinate (horizontal position)
            [~, order] = sort(centers(:, 1));
            sortedCenters = centers(order, :);
        
            % Transform the coordinates from the eye region to the face image
            transformedCenters = bsxfun(@plus, sortedCenters, eyeBox(1:2) - 1);
        
            % Transform the coordinates from the face image to the original image
            eyeCoordinates = bsxfun(@plus, transformedCenters, faceBox(1:2) - 1);
        
        else
            % If no eyes are detected using Hough, estimate
            if isempty(eyeBoxes)
                disp('Unable to detect both irises with alternative method.');

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
        end

    end

    % % Check if mouth is detected within the face region
    % if isempty(mouthBoxes)
    %     disp('No mouth detected within the face region.');
    % else
    %     % Use the first detected mouth
    %     mouthBox = mouthBoxes(1, :);
    % 
    %     % Calculate width (w) and height (h) of the mouth bounding box
    %     w = mouthBox(3);
    %     h = mouthBox(4);
    % 
    %     % Calculate the center of the mouth bounding box
    %     centerX = mouthBox(1) + w / 2;
    %     centerY = mouthBox(2) + h / 2;
    % 
    %     % Adjust mouth center coordinates relative to the original image
    %     mouthCoordinate = bsxfun(@plus, [centerX, centerY], faceBox(1:2) - 1);
    % end
end