function [rotatedImage, rotatedEyeCoordinates] = rotation_compensation(img, eyeCoordinates)

    % Extract eye positions
    x1 = eyeCoordinates(1, 1);
    y1 = eyeCoordinates(1, 2);
    x2 = eyeCoordinates(2, 1);
    y2 = eyeCoordinates(2, 2);

    % Calculate the angle in radians considering inverted y-axis
    % Adjust the order if necessary depending on how your coordinate system is defined
    angle_rad = atan2(-(y2 - y1), x2 - x1);

    % Convert angle to degrees
    angle_deg = rad2deg(angle_rad);

    % Rotate the image around its center
    rotatedImage = imrotate(img, -angle_deg, 'bicubic', 'crop');

    % Calculate the rotation matrix
    R = [cos(angle_rad) -sin(angle_rad); 
        sin(angle_rad) cos(angle_rad)];

    % Calculate the center of the image
    [height, width, ~] = size(img);
    imageCenter = [width/2; height/2];

    % Function to rotate coordinates
    function rotatedCoords = rotateCoordinates(coords, center)
        translatedCoords = [coords(1) - center(1); 
                            coords(2) - center(2)];
        rotatedCoords = R * translatedCoords;
        rotatedCoords = rotatedCoords + center;
    end

    % Rotate the eye coordinates
    rotatedEyePos1 = rotateCoordinates([x1, y1], imageCenter);
    rotatedEyePos2 = rotateCoordinates([x2, y2], imageCenter);
    rotatedEyeCoordinates = [rotatedEyePos1(1), rotatedEyePos1(2); rotatedEyePos2(1), rotatedEyePos2(2)];
end


