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
        % Assuming faceBoxes contains the detected face rectangles
        largestArea = 0;
        largestIndex = 0;
        
        for i = 1:size(faceBoxes, 1)
            % Extract coordinates of the current rectangle
            currentBox = faceBoxes(i, :);

            width = currentBox(3);
            height = currentBox(4);
        
            % Calculate the area of the current rectangle
            currentArea = width * height;
        
            % Check if the current rectangle has a larger area
            if currentArea > largestArea
                largestArea = currentArea;
                largestIndex = i;
            end
        end
    end

    % Get the largest eyebox
    faceBox = faceBoxes(largestIndex, :);

    % Crop the detected face region from the image
    faceImage = imcrop(image, faceBox);


    % IFaces = insertObjectAnnotation(image, 'rectangle', faceBox, 'Eyes');   
    % figure
    % imshow(IFaces)
    % title('Detected face');


    % DETECT EYES

    % Create eye and mouth detectors
    eyeDetector = vision.CascadeObjectDetector('EyePairBig');

    % eyeDetector.MergeThreshold = 10;
    eyeBoxes = eyeDetector(faceImage);

    if isempty(eyeBoxes)
        disp('No eyes detected within the face region.');

    else
        % Assuming eyeBoxes contains the detected eye rectangles
        largestArea = 0;
        largestIndex = 0;
        
        for i = 1:size(eyeBoxes, 1)
            % Extract coordinates of the current rectangle
            currentBox = eyeBoxes(i, :);

            width = currentBox(3);
            height = currentBox(4);
        
            % Calculate the area of the current rectangle
            currentArea = width * height;
        
            % Check if the current rectangle has a larger area
            if currentArea > largestArea
                largestArea = currentArea;
                largestIndex = i;
            end
        end
        
        % Get the largest eyebox
        eyeBox = eyeBoxes(largestIndex, :);
          
        % Crop the eye region from the face image
        eyeRegion = imcrop(faceImage, eyeBox);


        % IFaces = insertObjectAnnotation(faceImage, 'rectangle', eyeBox, 'Eyes');   
        % figure
        % imshow(IFaces)
        % title('Detected eyes');


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

        % Display the face image
        % imshow(image);
        % hold on;  % Keep the image displayed while plotting points
        % 
        % % Plot the left and right eye centers
        % % The '+' marker is used here; you can choose other markers like 'o', 'x', etc.
        % plot(eyeCoordinates(1, 1), eyeCoordinates(1, 2), 'r+', 'MarkerSize', 10); % Plot left eye center
        % plot(eyeCoordinates(2, 1), eyeCoordinates(2, 2), 'g+', 'MarkerSize', 10); % Plot right eye center
        % 
        % hold off;  % Release the hold to prevent further plotting on this image
        % title('Detected Eyes with Centers Marked');
        
    end
end