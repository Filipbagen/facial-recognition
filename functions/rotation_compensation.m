function [rotatedImage] = rotation_compensation(img)
    figure;
    imshow(img);
    [x, y] = ginput(2);
    
    % Calculate the angle in radians
    angle_rad = atan2(y(2) - y(1), x(2) - x(1));

    % Convert angle to degrees
    angle_deg = rad2deg(angle_rad);

    % Initialization
    [imageHeight, imageWidth, ~] = size(img);
    centerX = floor(imageWidth/2 + 1);
    centerY = floor(imageHeight/2 + 1);

    % Calculate translation values
    dx = centerX - x(1);
    dy = centerY - y(1);

    % Translate the image to position the left eye at the center
    translatedImage = imtranslate(img, [dx, dy]);
    
    % Rotate the translated image around the center with padding
    rot = imrotate(translatedImage, angle_deg, 'bicubic', 'loose');   

     % Initialization for rotated image
    [imageHeight2, imageWidth2, ~] = size(rot);
    centerX2 = floor(imageWidth2/2 + 1);
    centerY2 = floor(imageHeight2/2 + 1);

    % Calculate new coordinates for the second point after rotation
    newX = (x(2) - x(1)) * cos(angle_rad) + (y(2) - y(1)) * sin(angle_rad) + x(1);
    
    eye_dist=newX-x(1);
    
    % Define the cropping dimensions based on your requirements
    cropX = round(centerX2-(eye_dist/2)); % specify the starting X coordinate for cropping
    cropY = round(centerY2-(eye_dist)); % specify the starting Y coordinate for cropping
    cropWidth = round(2*(eye_dist)); % specify the width for cropping
    cropHeight = round((4/3)*cropWidth); % specify the height for cropping

    % Crop the rotated image
    croppedRotatedImage = rot(cropY : cropY + cropHeight - 1, cropX : cropX + cropWidth - 1, :);
    rotatedImage = imresize(croppedRotatedImage,[400,300]);
    %rotatedImage=croppedRotatedImage;

end

