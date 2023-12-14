% function [rotatedImage] = rotation_compensation(img, eyes)
%     x1 = eyes(1);
%     y1 = eyes(3);
%     x2 = eyes(2);
%     y2 = eyes(4);
% 
%     % Calculate the angle in radians
%     angle_rad = atan2(y2 - y1, x2 - x1);
% 
%     % Convert angle to degrees
%     angle_deg = rad2deg(angle_rad);
% 
%     % Initialization
%     [imageHeight, imageWidth, ~] = size(img);
%     centerX = floor(imageWidth/2 + 1);
%     centerY = floor(imageHeight/2 + 1);
% 
%     % Pad
%     padRow = round((imageHeight) / 2);
%     padCol = round((imageWidth) / 2);
%     zoomedImg = padarray(img, [padRow, padCol], 0, 'both');
% 
%     % Calculate translation values
%     dx = centerX - x1;
%     dy = centerY - y1;
% 
%     % Translate the image to position the left eye at the center
%     translatedImage = imtranslate(zoomedImg, [dx, dy]);
% 
%     % Rotate the translated image around the center with padding
%     rot = imrotate(translatedImage, angle_deg, 'bicubic', 'loose');   
% 
%      % Initialization for rotated image
%     [imageHeight2, imageWidth2, ~] = size(rot);
%     centerX2 = floor(imageWidth2/2 + 1);
%     centerY2 = floor(imageHeight2/2 + 1);
% 
%     % Calculate new coordinates for the second point after rotation
%     newX = (x2 - x1) * cos(angle_rad) + (y2 - y1) * sin(angle_rad) + x1;
% 
%     eye_dist = newX - x1;
% 
%     % Define the cropping dimensions based on your requirements
%     cropX = round(centerX2 - (eye_dist / 3)); % specify the starting X coordinate for cropping
%     cropY = round(centerY2 - ((2/3) * eye_dist)); % specify the starting Y coordinate for cropping
%     cropWidth = round((5 / 3) * (eye_dist)); % specify the width for cropping
%     cropHeight = round((4 / 3) * cropWidth); % specify the height for cropping
% 
%     % Crop the rotated image
%     croppedRotatedImage = rot(cropY : cropY + cropHeight - 1, cropX : cropX + cropWidth - 1, :);
%     rotatedImage = imresize(croppedRotatedImage, [400, 300]);
% end







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

    % Rotate the mouth coordinates
    % mouthX = mouthCoordinate(1);
    % mouthY = mouthCoordinate(2);
    % rotatedMouthPos = rotateCoordinates([mouthX, mouthY], imageCenter);

    % Assign the rotated mouth coordinates
    % rotatedMouthCoordinate = [rotatedMouthPos(1), rotatedMouthPos(2)];
end

